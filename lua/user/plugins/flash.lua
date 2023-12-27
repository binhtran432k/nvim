return {
	"folke/flash.nvim",
	event = "VeryLazy",
  enabled = false,
	opts = {},
	keys = {
		{
			"s",
			mode = { "n", "o", "x" },
			function()
				require("flash").jump()
			end,
			desc = "Flash",
		},
	},
}
