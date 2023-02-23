CREATE TABLE IF NOT EXISTS "users_to_projects" (
	"id" serial PRIMARY KEY NOT NULL,
	"user_id" integer NOT NULL,
	"project_id" integer NOT NULL,
	"role" varchar NOT NULL
);

ALTER TABLE branches DROP CONSTRAINT branches_repository_id_repositories_id_fk;
DO $$ BEGIN
 ALTER TABLE branches ADD CONSTRAINT branches_repository_id_repositories_id_fk FOREIGN KEY ("repository_id") REFERENCES repositories("id") ON DELETE cascade ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE environments DROP CONSTRAINT environments_project_id_projects_id_fk;
DO $$ BEGIN
 ALTER TABLE environments ADD CONSTRAINT environments_project_id_projects_id_fk FOREIGN KEY ("project_id") REFERENCES projects("id") ON DELETE cascade ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE environments DROP CONSTRAINT environments_branch_id_branches_id_fk;
DO $$ BEGIN
 ALTER TABLE environments ADD CONSTRAINT environments_branch_id_branches_id_fk FOREIGN KEY ("branch_id") REFERENCES branches("id") ON DELETE set null ON UPDATE set null;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE environments DROP CONSTRAINT environments_repository_id_repositories_id_fk;
DO $$ BEGIN
 ALTER TABLE environments ADD CONSTRAINT environments_repository_id_repositories_id_fk FOREIGN KEY ("repository_id") REFERENCES repositories("id") ON DELETE set null ON UPDATE set null;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE github_apps DROP CONSTRAINT github_apps_user_id_users_id_fk;
DO $$ BEGIN
 ALTER TABLE github_apps ADD CONSTRAINT github_apps_user_id_users_id_fk FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE cascade ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE github_apps DROP CONSTRAINT github_apps_org_id_organizations_id_fk;
DO $$ BEGIN
 ALTER TABLE github_apps ADD CONSTRAINT github_apps_org_id_organizations_id_fk FOREIGN KEY ("org_id") REFERENCES organizations("id") ON DELETE cascade ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE migrations DROP CONSTRAINT migrations_environment_id_environments_id_fk;
DO $$ BEGIN
 ALTER TABLE migrations ADD CONSTRAINT migrations_environment_id_environments_id_fk FOREIGN KEY ("environment_id") REFERENCES environments("id") ON DELETE cascade ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE organizations DROP CONSTRAINT organizations_user_id_users_id_fk;
DO $$ BEGIN
 ALTER TABLE organizations ADD CONSTRAINT organizations_user_id_users_id_fk FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE cascade ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE projects DROP CONSTRAINT projects_user_id_users_id_fk;

ALTER TABLE repositories DROP CONSTRAINT repositories_github_app_id_github_apps_id_fk;
DO $$ BEGIN
 ALTER TABLE repositories ADD CONSTRAINT repositories_github_app_id_github_apps_id_fk FOREIGN KEY ("github_app_id") REFERENCES github_apps("id") ON DELETE cascade ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE projects DROP COLUMN IF EXISTS "user_id";
ALTER TABLE projects ADD COLUMN "invite_code" varchar;
ALTER TABLE projects ADD COLUMN "invite_token" varchar;
DO $$ BEGIN
 ALTER TABLE users_to_projects ADD CONSTRAINT users_to_projects_user_id_users_id_fk FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
 ALTER TABLE users_to_projects ADD CONSTRAINT users_to_projects_project_id_projects_id_fk FOREIGN KEY ("project_id") REFERENCES projects("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

DROP INDEX IF EXISTS unique_project_to_user;
CREATE UNIQUE INDEX IF NOT EXISTS users_to_projects_user_id_project_id_index ON users_to_projects ("user_id","project_id");
CREATE UNIQUE INDEX IF NOT EXISTS unique_invite_code ON projects ("invite_code");
CREATE UNIQUE INDEX IF NOT EXISTS unique_invite_token ON projects ("invite_token");