import 'schema-format.dart';

/// We use these constants to mirror your JS usage, so that code
/// looks similar in your Dart migration.
const copyValue = SchemaLeaf.copy;
const convertValue = SchemaLeaf.convert;

/// Recursively convert [input] using [schema]. 
///
/// [conversionFn] is only used when we hit a 'convert' leaf.
/// Everything else is either copied as-is or recurses into arrays/objects.
dynamic convert<From, To>(
  To Function(From v) conversionFn,
  Schema schema,
  dynamic input,
) {
  // If it's a leaf node:
  if (schema is SchemaLeaf) {
    switch (schema) {
      case SchemaLeaf.copy:
        return input; // do nothing
      case SchemaLeaf.convert:
        return conversionFn(input as From);
    }
  }

  // If it's an array schema:
  if (schema is SchemaArray) {
    if (input is List) {
      return input
          .map((element) => convert<From, To>(conversionFn, schema.item, element))
          .toList();
    } else {
      throw Exception('Expected a List for array schema, got: $input');
    }
  }

  // If it's an object schema:
  if (schema is SchemaObject) {
    if (input is Map<String, dynamic>) {
      final output = <String, dynamic>{};
      // For each field in the schema
      schema.fields.forEach((key, schemaField) {
        // If there's a derive function, run it first
        if (schemaField.derive != null) {
          final derivedValue = schemaField.derive!(input);
          if (derivedValue != null) {
            // Modify the input with the derived value
            input[key] = derivedValue;
          }
        }

        // If the key is missing
        if (!input.containsKey(key)) {
          if (schemaField.required) {
            throw Exception('Missing required key: $key');
          }
          // If it's optional and missing, just skip
        } else {
          // If the input value is null, just copy null
          final value = input[key];
          if (value == null) {
            output[key] = null;
          } else {
            // Recurse
            output[key] = convert<From, To>(conversionFn, schemaField.schema, value);
          }
        }
      });
      return output;
    } else {
      throw Exception('Expected a Map<String,dynamic> for object schema, got: $input');
    }
  }

  // If none of the above matched (shouldn't happen if the schema is well-formed).
  throw Exception('Unknown schema type encountered.');
}

/// Replicates your "derived()" function, which marks the property as required 
/// and includes a derive callback.
SchemaProperty derived(
  Schema schema,
  dynamic Function(Map<String, dynamic>) deriveFn,
) {
  return SchemaProperty(required: true, schema: schema, derive: deriveFn);
}

/// Marks a property as required, no derive function.
SchemaProperty requiredProp(Schema schema) {
  return SchemaProperty(required: true, schema: schema);
}

/// Marks a property as optional, no derive function.
SchemaProperty optionalProp(Schema schema) {
  return SchemaProperty(required: false, schema: schema);
}
