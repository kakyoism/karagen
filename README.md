# karagen

`karagen` *extracts* the accompaniment track from a song, powered by [`Deezer Spleeter`](https://research.deezer.com/projects/spleeter.html).

What `karagen` is

- A frontend of `Spleeter`
- A workflow customized to serve karaoke enthusiasts who have trouble finding the official instrumental version of their favourite songs

What `karagen` is NOT

- A full-fledged intelligent solution towards source separation for arbitrary music



## Getting Started

To extract the accompaniment of a song

- Click the button `Pick a Song`. 
- Find a song using the pop-up file dialog, then click `Select Song`. On its right side, you should see the the full path to the song file if we succeed.
- Click the button `Output Folder`.
- Find a target folder you want using the pop-up file dialog, then click `Select Folder`. On its right side, you should see the full path to the output folder if we succeed.
- Click the floating `+` button at the bottom right of the window. The background worker will start doing the real work. 
- Wait till the background worker finishes its job.

If all goes well, the system explorer will open the output folder, where you should see two files

- `accompaniment.wav`
- `vocal.wav`

The first file is what you want. Congratulations! Now you have your pseudo-instrumental version of your favourite song. 

Finally, let's start working on our hit cover `^_^`.



## Limitations and Future Work

- `Spleeter` needs to retrieve machine learning models from remote services, so it requires a stable internet connection (possiblly with a VPN in some countries), at least on the first run. 
- We process the entire song, which may erase ALL the vocals including some backing vocals that you might intend to keep. A workaround is to do your own multi-track comping to mix in the original backing-vocal segments, using an external audio editor app such as [`Audacity`](https://www.audacityteam.org/). 
- We use the default parameters for the underlying algorithm, which isn't always perfect. For simplicity, we postpone the implementation of the parameter tweaks for power users until absolutely needed.
- The output audio quality is bound by your input audio quality. Prefer using higher fidelity version of the song as your input file. Don't expect a better result just because the output format is `.wav` but your input is a low-bitrate `.mp3`.
- Batch processing will be supported in future releases.



## Releases

v0.1.4

- Fixed: Child process fails when paths contain unicode characters
- Fixed: Long text goes beyond window boundary

v0.1.3

- Added installer for Windows
- Minor UI tweaks
- Added app icon

v0.1.2

- Better user docs

v0.1.1

- Generating accompaniment
- Opening output folder automatically



## Acknowledgements

<div>Icons made by <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>



## Contact

The issue tracker: https://github.com/kakyoism/karagen/issues

