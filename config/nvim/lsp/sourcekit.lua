---@type vim.lsp.Config
return {
	-- Use the active Xcode toolchain (SDKs, modules, and SPM deps).
	cmd = { "xcrun", "sourcekit-lsp" },
	filetypes = { "swift", "objc", "objcpp" },
}
