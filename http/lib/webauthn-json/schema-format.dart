/// Represents the leaf node in the schema: either "copy" or "convert"
enum SchemaLeaf implements Schema { copy, convert }

/// The overarching base class for any schema type.
abstract class Schema {}

/// A schema that indicates a list/array of items, all matching [item].
class SchemaArray extends Schema {
  final Schema item;
  SchemaArray(this.item);
}

/// A schema that indicates an object (Map) where each key has a [SchemaProperty].
class SchemaObject extends Schema {
  final Map<String, SchemaProperty> fields;
  SchemaObject(this.fields);
}

/// A single property definition within a [SchemaObject].
/// 
/// - [required] indicates if this property must appear in the input map.
/// - [schema] is the schema describing how to convert this property's value.
/// - [derive] is an optional function that can inject/derive a value before conversion.
class SchemaProperty {
  final bool required;
  final Schema schema;
  final dynamic Function(Map<String, dynamic> v)? derive;

  SchemaProperty({
    required this.required,
    required this.schema,
    this.derive,
  });
}
