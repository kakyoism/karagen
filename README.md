# [karagen](https://kakyoism.github.io/karagen/)

## Overview

When you are dying to cover your favourite song but cannot find a published instrumental track for it, `karagen` is to the rescue. It helps you extract "the accompaniment track" from your local song file so that you could record your own performance on top of it.

What `karagen` is

- A frontend of [`Deezer Spleeter`](https://research.deezer.com/projects/spleeter.html)
- A workflow customized to serve karaoke enthusiasts who have trouble finding the official instrumental version of their favourite songs

What `karagen` is NOT

- A full-fledged intelligent solution towards source separation for arbitrary music



## Getting karagen

- Download the installer for our platform from [the project release page](https://github.com/kakyoism/karagen/releases)



## Getting Ready

### Windows

- Double-click the `install_karagen_<version>.exe` to install `karagen`.
- Accept all prompts when the installer attempts to change your registry key and permissions. 
- If your anti-virus software prompts to block the installer activities, then do NOT block.
- At the end of the installation, a post-install script will run automatically. Leave the checkmark on and click finish. Wait till the script finishes its job.
- If your system uses a non-English locale, then ensure Unicode characters all use UTF-8 as their charset. Check this option in Control Panel's `Region`> `Administrative`settings.

### macOS

- Double-click the `install_karagen_<version>.dmg` to mount the installer.
- Drag the folder `karagen` into `/Applications` folder.
- Open the builtin `Terminal.app` under `/Applications/Utilities`; Alternatively, press `F4` to call up `Launchpad`, and then type in `Terminal`.
- Ensure you have a stable internet connection; you may need a proxy or VPN in some countries.
- *Optional*: If you are located in mainland China and your internet service (with or without a VPN) does not give you access to the default servers of the pacakge manager `Homebrew `, you must install `Homebrew` using the bundled installer script:
  - In the Terminal window, type in: `/Applications/karagen/install_homebrew_cn.sh` and hit `Enter`. 
  - The script will list the available local Chinese servers. You must then pick one by entering its index and hit `Enter`.
- In the open Terminal window, type in: `/Applications/karagen/install_karagen.sh` and hit `Enter` to install dependencies. You could also drag the `.sh` file into the Terminal window and then hit `Enter` to speed it up a little.
- In Finder, Go to the folder `/Applications/karagen`, double-click `karagen.workflow` (if your Finder hides file extensions, you will see a file named `karagen` with a telephone icon instead) to install the workflow as a system service. Click `Install` to confirm when the system prompts to continue.

## Getting Started

To extract the accompaniment of a song, follow the platform-specific procedures below.

### Windows

- Double-click the `karagen` desktop shortcut to bring up the UI.
- Click the button `Pick a Song`. 
- Find a song using the pop-up file dialog, then click `Select Song`. After that, the selected file path will appear on the right side of the button.
- Click the button `Output Folder`.
- Find a target folder you want using the pop-up file dialog, then click `Select Folder`. Then the full path to the selected folder will appear on the right side of the button.
- Click the floating `+` button at the bottom right of the window. The background worker will start doing the real work. 
- Wait till the background worker finishes its job.

### macOS

- Open `Finder` and navigate to your target song file.
- Right-click the song file and select `Quick Actions > karagen` or `Services > karagen`.
- The first run will likely fail upfront, and you'll be prompted that `libsndfile.dylib` is  not trusted. Don't worry. Simply head for `System Preferences > Security & Privacy > General` to enable it.
- Repeat the first two steps, during which you might be prompted a few times for permissions again; simply confirm all the prompts, and the progress cogwheel will start spinning on the task bar, showing `karagen` is at work.
- Wait till the background worker finishes its job.
- Note that the output folder is always `~/Desktop/karagen`.

### Results

If all goes well, the system explorer will open the output folder, where you should see two files

- `accompaniment.wav`
- `vocal.wav`

**The first file is what you want**. Congratulations! Now you have your pseudo-instrumental version of your favourite song. 

Finally, let's start working on our hit cover `^_^`.



## Limitations and Future Work

We are aware of the following limitations of `karagen` and will strive to improve upon them

- `Spleeter` needs to retrieve machine learning models from remote services, so it requires a stable internet connection (possiblly with a VPN in some countries), at least on the first run. For your convenience, we include a snapshot of the pretrained model in the distribution. However, the snapshot may fall behind the upstream, so if you have an excellent internet condition, you might want to periodically remove the pre-installed model so that the `Spleeter` backend could have a chance to update the model automatically.
- We process the entire song, which may erase ALL the vocals including some backing vocals that you might intend to keep. A workaround is to do your own multi-track comping to inject the original backing-vocal segments, using an external audio editor such as [`Audacity`](https://www.audacityteam.org/). 
- `Spleeter` 's algorithm is customizable. However, we use its default parameters, which isn't always perfect. For simplicity, we postpone the implementation of the parameter tweaks, which is for power users only.
- The output audio quality is bound by your input audio quality. Prefer using a high fidelity version of the song as your input file. Don't expect a better result just because the output format is `.wav` but your input is a low-bitrate `.mp3`.
- Batch processing is not yet supported.



## Releases

v0.2.3

- macOS: Added pretrained models to installer to avoid internet problems

v0.2.2

- macOS: Added installation support for mainland China users.

v0.2.1

- Bug fixes.

v0.2.0

- Windows: Improved the installation experience.
- macOS: Implemented platform-specific procedure
- macOS: Added installer

v0.1.7

- Windows: Included dependencies to avoid installation failure due to internet issues

v0.1.6

- Added more user docs
- Added build pipeline on Windows

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

- Icons made by [Freepik](https://www.freepik.com) from [Flaticon](https://www.flaticon.com/).
- `Homebrew` installer for mainland China made by [cunkai.wang@foxmail.com](cunkai.wang@foxmail.com).



## FAQ

### The progress ring seems to spin forever.

- On the first run, `karagen`'s backend must download data from a remove server, which may take a few minutes depending on your internet connection.
- In some country, you may need a VPN to complete the download.
- Once the data is fully downloaded, the subsequent runs will be much faster.

### The progress ring spins for a while and then fails.

- Check under `karagen` folder. Do you see `pretrained_models` folder?
  - If YES, then do you see `2stems` folder? It should contain at least 6 files, one of which is called `checkpoint`; otherwise, delete the `pretrained_models` folder and try again.
  - If NO, then check our internet connection. 

### The program seems to succeed (or fail) instantly, but I don't see the generated files.

-  Are there Unicode characters in your target file path? On Windows, you must ensure UTF-8 be used as the charset for all Unicode characters. Check this through your Control Panel's Region settings.



## Contact

For tech support, visit [the issue tracker](https://github.com/kakyoism/karagen/issues).

