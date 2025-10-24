return {
	"aranborkum/pr-tools.nvim",
	dev = false,
	keys = {
		{
			"<leader>prl",
			"<cmd>CreateSlackPrLink<cr>",
			desc = "Create pull request link for Slack",
		},
		{
			"<leader>opr",
			"<cmd>OpenPrInBrowser<cr>",
			desc = "Open the pull request in your default browser",
		},
		{
			"<leader>cpr",
			"<cmd>CreatePullRequest<cr>",
			desc = "Create new pull request (prompts for title)",
		},
		{
			"<leader>epr",
			"<cmd>EditPullRequestDescription<cr>",
			desc = "Edit the body of the pull request",
		},
		{
			"<leader>prc",
			"<cmd>PullRequestCheckSummary<cr>",
			desc = "Display the current status of the pull requests checks",
		},
		{
			"<leader>prr",
			"<cmd>MarkPullRequestAsReady<cr>",
			desc = "Mark a draft PR as ready",
		},
		{
			"<leader>pgs",
			"<cmd>SwitchPostgresInstance<cr>",
			desc = "Switch postgres instance",
		},
	},
	opts = {
		pr = {
			open_in_draft = true,
			slack_link_emoji = "pr-outline",
		},
		db = {
			db_instance_dir = "/Users/aran.borkum/Library/Application Support/Postgres/var-17",
			pg_ctl = "/Applications/Postgres.app/Contents/Versions/17/bin/pg_ctl",
		},
	},
}
