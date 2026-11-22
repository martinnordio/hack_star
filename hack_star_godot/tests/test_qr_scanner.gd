extends GutTest


func test_outside_the_web_it_fails_with_not_web() -> void:
	var scanner: QrScanner = autofree(QrScanner.new())
	add_child(scanner)
	watch_signals(scanner)
	scanner.start()
	assert_signal_emitted_with_parameters(scanner, "failed", [QrScanner.NOT_WEB])
	assert_signal_not_emitted(scanner, "scanned")
	assert_false(scanner.scanning)


func test_the_desktop_and_the_headless_run_cannot_scan() -> void:
	assert_false(QrScanner.can_scan())
