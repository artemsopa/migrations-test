ALTER TABLE projects ADD COLUMN "repository_id" integer;
ALTER TABLE environments DROP CONSTRAINT environments_repository_id_repositories_id_fk;

DO $$ BEGIN
 ALTER TABLE projects ADD CONSTRAINT projects_repository_id_repositories_id_fk FOREIGN KEY ("repository_id") REFERENCES repositories("id") ON DELETE set null ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

ALTER TABLE environments DROP COLUMN IF EXISTS "repository_id";