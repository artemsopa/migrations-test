CREATE UNIQUE INDEX IF NOT EXISTS unique_repo_to_app ON repositories ("github_app_id","repository_git_id");