import dotenv from 'dotenv';
import { DataSource } from "typeorm";
dotenv.config();



const AppDataSource = new DataSource({
  type: process.env.DB_TYPE,
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT, 10),
  username: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  entities: ["src/entities/**/*.js"], 
  migrations: ["src/migrations/**/*.js"],
  synchronize: false,
  logging: true,
});

export{ AppDataSource }; // Export directly
