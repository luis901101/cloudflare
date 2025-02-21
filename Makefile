generate-code:
	rm -rf .dart_tool/build
	dart run build_runner build --delete-conflicting-outputs

format:
	dart format .

fix:
	dart fix --apply

checkPublish:
	dart pub publish --dry-run

publish:
	dart pub publish