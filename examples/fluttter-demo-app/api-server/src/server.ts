import express from 'express';
import { json } from 'body-parser';
import { POST } from './controllers/turnkey-api';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(__dirname, '../../.env') });


const app = express();
const PORT = process.env.BACKEND_API_PORT || 3000;

app.use(json());

app.post('/api', POST);

app.listen(PORT, () => {

  console.log(`Server is running on http://localhost:${PORT}`);
});