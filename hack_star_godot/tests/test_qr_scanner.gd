extends GutTest


func test_outside_the_web_it_fails_with_not_web() -> void:
	var scanner: QrScanner = autofree(QrScanner.new())
	add_child(scanner)
	watch_signals(scanner)
	scanner.start()
	assert_signal_emitted_with_parameters(scanner, "failed", [QrScanner.NOT_WEB])
	assert_signal_not_emitted(scanner, "scanned")
	assert_false(scanner.scanning)
