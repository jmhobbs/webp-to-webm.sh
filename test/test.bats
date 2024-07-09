setup() {
  bats_load_library 'bats-support'
  bats_load_library 'bats-assert'
  bats_load_library 'bats-file'
  DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
  PATH="$DIR/../:$PATH"
}

teardown() {
  rm -f test.webp
  rm -f test.webm
}

@test "fails when no arguments are passed" {
  run webp-to-webm.sh

  assert_failure
  assert_output --partial "error: required arguments missing"
  assert_output --partial "usage:"
}

@test "fails when only one argument is passed" {
  run webp-to-webm.sh test.webp

  assert_failure
  assert_output --partial "error: required arguments missing"
  assert_output --partial "usage:"
}

@test "fails when input file does not exist" {
  run webp-to-webm.sh test.webp test.webm

  assert_failure
  assert_output --partial "error: input file not found"
}

@test "fails when output file exists" {
  touch test.webp
  touch test.webm
  run webp-to-webm.sh test.webp test.webm

  assert_failure
  assert_output --partial "error: output file exists"
  rm test.webp test.webm
}

@test "extracts correct number of frames from webp" {
  cp "$DIR/test.webp" .
  run webp-to-webm.sh test.webp test.webm

  assert_success
}

@test "converts webp to webm" {
  cp "$DIR/test.webp" .
  run webp-to-webm.sh test.webp test.webm

  assert_success
  # Did it get the correct frame count?
  assert_output --partial "Extracting 5 frames from test.webp"
  assert_file_exists test.webm

  run ffprobe -i test.webm
  assert_success
  # Did it get the correct framerate?
  # 100ms duration on source -> 10fps
  assert_output --partial "10 fps"
  assert_output --partial "Duration: 00:00:00.50"
}
