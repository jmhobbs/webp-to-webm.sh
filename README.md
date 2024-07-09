[![Test Status](https://github.com/jmhobbs/webp-to-webm.sh/actions/workflows/test.yaml/badge.svg?branch=main)](https://github.com/jmhobbs/webp-to-webm.sh/actions/workflows/test.yaml)

# Convert Animated webp To webm

FFmpeg does not directly support animated webp files for conversion.

This script uses [webpmux](https://developers.google.com/speed/webp/download) to extract all the frames from the file, and make a video out of them with FFmpeg.

## Caveats

This script is designed to run on a Posix system, you can try it with WSL on Windows but this is untested.

This script expects all frames in the animation to have the same duration. This is generally true of animations derived from video sources, but may not be true of animations created from scratch.

Output webm files are not optimized for size. You can post-process them if you need a smaller file.

Everything is dependent on `webpmux` output, if it changes, this script will break. It has been tested with version 1.4.0

# Installing

Ensure you have the following installed:

- [FFmpeg](https://ffmpeg.org/)
- [webpmux](https://developers.google.com/speed/webp/download)

If you are a Homebrew user, you can install the script as well as the dependencies with my [tap](https://github.com/jmhobbs/homebrew-tools)

```
brew install jmhobbs/tools/webp-to-webm.sh
```

# Usage

```
usage: ./webp-to-webm.sh <input.webp> <output.webm>
```
