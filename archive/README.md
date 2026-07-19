# Archive — the original 2020 installation

This folder preserves the original version of Anpu's Feather exactly as it
was created by Lei Lin and Kris Haamer at the NCKU ICID Digital Design class
(Tainan, Taiwan, April 2020).

- `feather/` — the Processing (Java) sketch. It ran fullscreen on a machine
  with a **Kinect v2** (via the KinectPV2 library) for live body tracking,
  or played back the recorded skeleton files in `feather/data/*.txt`.
- `project/` — work-in-progress screenshots and example wisdom cards.

To run it you need [Processing](https://processing.org) with the Sound and
KinectPV2 libraries. Open `feather/feather.pde` and press Run.

The playable web version at the repository root is a faithful port of this
sketch — same narrative, same artwork, same music, same recorded movement
data — with the pointer standing in for the Kinect.
