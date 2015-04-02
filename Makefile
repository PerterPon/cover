
-OUT_DIR := out/

-BIN_COFFEE := ./node_modules/coffee-script/bin/coffee

publush:
	@rm -rf $(-OUT_DIR)
	@echo 'copy files'
	@mkdir -p $(-OUT_DIR)
	@cp -rf ./lib $(-OUT_DIR)
	@echo 'compile coffee files'
	@$(-BIN_COFFEE) -cb $(-OUT_DIR)
	@find $(-OUT_DIR) -name "*.coffee" -exec rm -rf {} \;
