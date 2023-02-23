CREATE TABLE IF NOT EXISTS branches (
	"id" serial PRIMARY KEY NOT NULL,
	"repository_id" integer NOT NULL,
	"branch" varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS environments (
	"id" serial PRIMARY KEY NOT NULL,
	"project_id" integer NOT NULL,
	"branch_id" integer,
	"repository_id" integer,
	"env_name" varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS github_apps (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"installation_id" integer NOT NULL,
	"org_id" integer NOT NULL
);

CREATE TABLE IF NOT EXISTS migrations (
	"id" serial PRIMARY KEY NOT NULL,
	"environment_id" integer NOT NULL,
	"migration_name" varchar NOT NULL,
	"snapshot" jsonb NOT NULL,
	"migration_path" varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS organizations (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"type" varchar NOT NULL,
	"photo_path" varchar NOT NULL,
	"user_id" integer NOT NULL,
	"github_id" integer NOT NULL
);

CREATE TABLE IF NOT EXISTS projects (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"project_name" varchar NOT NULL
);

CREATE TABLE IF NOT EXISTS repositories (
	"id" serial PRIMARY KEY NOT NULL,
	"github_app_id" integer NOT NULL,
	"repository" varchar NOT NULL,
	"repository_git_id" integer NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
	"id" serial PRIMARY KEY NOT NULL,
	"github_id" integer NOT NULL,
	"github_name" varchar NOT NULL,
	"email" varchar NOT NULL,
	"photo_path" varchar NOT NULL
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
 ALTER TABLE environments ADD CONSTRAINT environments_branch_id_branches_id_fk FOREIGN KEY ("branch_id") REFERENCES branches("id") ON DELETE set null;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE environments ADD CONSTRAINT environments_repository_id_repositories_id_fk FOREIGN KEY ("repository_id") REFERENCES repositories("id") ON DELETE set null;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE github_apps ADD CONSTRAINT github_apps_user_id_users_id_fk FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE github_apps ADD CONSTRAINT github_apps_org_id_organizations_id_fk FOREIGN KEY ("org_id") REFERENCES organizations("id") ON DELETE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE migrations ADD CONSTRAINT migrations_environment_id_environments_id_fk FOREIGN KEY ("environment_id") REFERENCES environments("id") ON DELETE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE organizations ADD CONSTRAINT organizations_user_id_users_id_fk FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE projects ADD CONSTRAINT projects_user_id_users_id_fk FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE repositories ADD CONSTRAINT repositories_github_app_id_github_apps_id_fk FOREIGN KEY ("github_app_id") REFERENCES github_apps("id") ON DELETE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS unique_branch_to_repository ON branches ("repository_id","branch");
CREATE UNIQUE INDEX IF NOT EXISTS unique_env_name_to_project ON environments ("env_name","project_id");
CREATE UNIQUE INDEX IF NOT EXISTS unique_installation_to_user ON github_apps ("installation_id","org_id");
CREATE UNIQUE INDEX IF NOT EXISTS unique_migration_to_environment ON migrations ("environment_id","migration_name");
CREATE UNIQUE INDEX IF NOT EXISTS unique_project_to_user ON projects ("project_name","user_id");
CREATE UNIQUE INDEX IF NOT EXISTS unique_github_id ON users ("github_id");