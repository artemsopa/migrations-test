CREATE TABLE IF NOT EXISTS "journals" (
	"id" serial PRIMARY KEY NOT NULL,
	"env_id" integer NOT NULL,
	"journal" jsonb NOT NULL
);

ALTER TABLE migrations RENAME COLUMN "migration_name" TO "name";
ALTER TABLE migrations ADD COLUMN "created_at" bigint NOT NULL;
ALTER TABLE migrations ADD COLUMN "index" integer NOT NULL;
ALTER TABLE migrations ADD COLUMN "diff_migration" jsonb;
DO $$ BEGIN
 ALTER TABLE journals ADD CONSTRAINT journals_env_id_environments_id_fk FOREIGN KEY ("env_id") REFERENCES environments("id") ON DELETE cascade ON UPDATE no action;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS journals_env_id_index ON journals ("env_id");