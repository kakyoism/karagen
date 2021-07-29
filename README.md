# karagen

`karagen` *extracts* the accompaniment track from a song, powered by [`Deezer Spleeter`](https://research.deezer.com/projects/spleeter.html).

What `karagen` is

- A frontend of `Spleeter`
- A workflow customized to serve karaoke enthusiasts who have trouble finding the official instrumental version of their favourite songs

What `karagen` is NOT

- A full-fledged intelligent solution towards source separation for arbitrary music


## Getting Ready

**[WIP] The installer distribution is under construction ...**

Windows

- Double-click the `install_karagen_<version>.exe` to install `karagen`.
- Accept all prompts when the installer attempt to change your registry key and permissions. 
- If your anti-virus software prompts to block the installer activities, then do NOT block.
- At the end of the installation, a post-install script will run automatically. Leave the checkmark on and click finish. Wait till the script finishes its job.
- Ensure Unicode characters all use UTF-8 as their charset. Configure this in Control Panel's `Region`> `Administrative`settings if you have not.


macOS

- Double-click the `install_karagen_<version>.pkg` to install `karagen`.


## Getting Started

To extract the accompaniment of a song

- Click the button `Pick a Song`. 
- Find a song using the pop-up file dialog, then click `Select Song`. Then the full path to the selected file will appear on the right side of the button.
- Click the button `Output Folder`.
- Find a target folder you want using the pop-up file dialog, then click `Select Folder`. Then the full path to the selected folder will appear on the right side of the button.
- Click the floating `+` button at the bottom right of the window. The background worker will start doing the real work. 
- Wait till the background worker finishes its job.

If all goes well, the system explorer will open the output folder, where you should see two files

- `accompaniment.wav`
- `vocal.wav`

**The first file is what you want**. Congratulations! Now you have your pseudo-instrumental version of your favourite song. 

Finally, let's start working on our hit cover `^_^`.



## Limitations and Future Work

- `Spleeter` needs to retrieve machine learning models from remote services, so it requires a stable internet connection (possiblly with a VPN in some countries), at least on the first run. 
- We process the entire song, which may erase ALL the vocals including some backing vocals that you might intend to keep. A workaround is to do your own multi-track comping to mix in the original backing-vocal segments, using an external audio editor app such as [`Audacity`](https://www.audacityteam.org/). 
- We use the default parameters for the underlying algorithm, which isn't always perfect. For simplicity, we postpone the implementation of the parameter tweaks for power users until it proves absolutely necessary.
- The output audio quality is bound by your input audio quality. Prefer using a high fidelity version of the song as your input file. Don't expect a better result just because the output format is `.wav` but your input is a low-bitrate `.mp3`.
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



## FAQ

### The progress ring seems to spin for ever.

- On the first run, `karagen`'s backend must download data from remove server, which may take a few minutes depending on your internet connection.
- In some country, you may need a VPN to complete the download.
- Once the data is fully downloaded, the subsequent runs will be much faster.

### The progress ring spins for a while and then fails.

- Check under `karagen` folder. Do you see `pretrained_models` folder?
  - If YES, then do you see `2stems` folder? It should contain at least 6 files, one of which is called `checkpoint`; otherwise, delete the `pretrained_models` folder and try again.
  - If NO, then check our internet connection. 

### The program seems to succeed (or fail) instantly, but I don't see the generated files.

-  Are there Unicode characters in your target file path? On Windows, you must ensure UTF-8 be used as the charset for all Unicode characters. Check this through your Control Panel's Region settings.



## Contact

The issue tracker: https://github.com/kakyoism/karagen/issues

