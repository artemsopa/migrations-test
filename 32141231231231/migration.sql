CREATE TABLE IF NOT EXISTS branches (
	"id" serial PRIMARY KEY NOT NULL,
	"repository_id" integer,
	"branch" varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS environments (
	"id" serial PRIMARY KEY NOT NULL,
	"project_id" integer,
	"branch_id" integer,
	"repository_id" integer,
	"env_name" varchar DEFAULT '' NOT NULL
);

CREATE TABLE IF NOT EXISTS github_app (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer,
	"installation_id" integer NOT NULL
);

CREATE TABLE IF NOT EXISTS migrations (
	"id" serial PRIMARY KEY NOT NULL,
	"environment_id" integer,
	"migration_name" varchar NOT NULL,
	"snapshot" jsonb NOT NULL
);

CREATE TABLE IF NOT EXISTS projects (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer,
	"project_name" varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS repositories (
	"id" serial PRIMARY KEY NOT NULL,
	"github_app_id" integer,
	"repository" varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
	"id" serial PRIMARY KEY NOT NULL,
	"github_id" integer NOT NULL,
	"github_name" varchar NOT NULL,
	"email" varchar NOT NULL,
	"photo_path" varchar NOT NULL,
	"access_token" varchar NOT NULL,
	"refresh_token" varchar NOT NULL,
	"role" varchar NOT NULL
);

DO $$ BEGIN
 ALTER TABLE branches ADD CONSTRAINT branches_repository_id_repositories_id_fk FOREIGN KEY ("repository_id") REFERENCES repositories("id") ON DELETE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE environments ADD CONSTRAINT environments_project_id_projects_id_fk FOREIGN KEY ("project_id") REFERENCES projects("id");
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE environments ADD CONSTRAINT environments_branch_id_branches_id_fk FOREIGN KEY ("branch_id") REFERENCES branches("id");
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE environments ADD CONSTRAINT environments_repository_id_repositories_id_fk FOREIGN KEY ("repository_id") REFERENCES repositories("id");
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE github_app ADD CONSTRAINT github_app_user_id_users_id_fk FOREIGN KEY ("user_id") REFERENCES users("id");
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE migrations ADD CONSTRAINT migrations_environment_id_environments_id_fk FOREIGN KEY ("environment_id") REFERENCES environments("id");
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE projects ADD CONSTRAINT projects_user_id_users_id_fk FOREIGN KEY ("user_id") REFERENCES users("id");
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE repositories ADD CONSTRAINT repositories_github_app_id_github_app_id_fk FOREIGN KEY ("github_app_id") REFERENCES github_app("id") ON DELETE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS unique_installation_to_user ON github_app ("installation_id","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS unique_migration_to_environment ON migrations ("environment_id","migration_name");
CREATE UNIQUE INDEX IF NOT EXISTS unique_project_to_user ON projects ("project_name","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS unique_github_id ON users ("github_id");