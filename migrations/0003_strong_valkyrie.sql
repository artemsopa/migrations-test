ALTER TABLE projects RENAME COLUMN "invite_code" TO "code";
ALTER TABLE projects ALTER COLUMN "invite_token" SET NOT NULL;
ALTER TABLE projects ALTER COLUMN "code" SET NOT NULL;
DROP INDEX IF EXISTS unique_invite_code;
CREATE UNIQUE INDEX IF NOT EXISTS unique_project_code ON projects ("code");