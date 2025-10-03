return {
	"aranborkum/pr-tools.nvim",
	dev = true,
	keys = {
		{
			"<leader>prl",
			"<cmd>CreateSlackPrLink<cr>",
			desc = "Create pull request link for Slack",
		},
		{
			"<leader>opr",
			"<cmd>OpenPrInBrowser<cr>",
			desc = "Open the pull request in your default browser", },
		{
			"<leader>cpr",
			"<cmd>CreatePullRequest<cr>",
			desc = "Create new pull request (prompts for title)",
		},
		{
			"<leader>epr",
			"<cmd>RunPrToolsTest<cr>",
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
		}
	},
	opts = {
		open_in_draft = true,
	},
}
