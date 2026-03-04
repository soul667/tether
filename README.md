![Frame 122](https://github.com/user-attachments/assets/5ff719c1-2be4-490b-b298-1539136bacbc)

# Tether: Autonomous Functional Play with Correspondence-Driven Trajectory Warping

<div align="center">

<div align="center">
  <p style>
    <a href="https://tether-research.github.io"><strong>🌐 Website</strong></a> | 
    <a href="https://arxiv.org/abs/2603.03278"><strong>📄 Paper</strong></a>
  </p>
</div>

[William Liang](https://willjhliang.github.io), [Sam Wang](https://samuelwang23.github.io/), [Hung-Ju Wang](https://www.linkedin.com/in/hungju-wang),<br>
[Osbert Bastani](https://obastani.github.io/), [Yecheng Jason Ma<sup>†</sup>](https://jasonma2016.github.io/), [Dinesh Jayaraman<sup>†</sup>](https://www.seas.upenn.edu/~dineshj/)

[![Python Version](https://img.shields.io/badge/Python-3.10-blue.svg)](https://github.com/tether-research/tether)
[<img src="https://img.shields.io/badge/Framework-PyTorch-red.svg"/>](https://pytorch.org/)
[![GitHub license](https://img.shields.io/github/license/tether-research/tether)](https://github.com/tether-research/tether/blob/main/LICENSE)

______________________________________________________________________

</div>

The ability to conduct and learn from interaction and experience is a central challenge in robotics, offering a scalable alternative to labor-intensive human demonstrations. However, realizing such "play" requires (1) a policy robust to diverse, potentially out-of-distribution environment states, and (2) a procedure that continuously produces useful robot experience. To address these challenges, we introduce Tether, a method for autonomous functional play involving structured, task-directed interactions. First, we design a novel open-loop policy that warps actions from a small set of source demonstrations (<=10) by anchoring them to semantic keypoint correspondences in the target scene. We show that this design is extremely data-efficient and robust even under significant spatial and semantic variations. Second, we deploy this policy for autonomous functional play in the real world via a continuous cycle of task selection, execution, evaluation, and improvement, guided by the visual understanding capabilities of vision-language models. This procedure generates diverse, high-quality datasets with minimal human intervention. In a household-like multi-object setup, our method is the first to perform many hours of autonomous multi-task play in the real world starting from only a handful of demonstrations. This produces a stream of data that consistently improves the performance of closed-loop imitation policies over time, ultimately yielding over 1000 expert-level trajectories and training policies competitive with those learned from human-collected demonstrations.

# Installation
The following instructions will install everything three conda environments: one main environment for the tether code, and two conda environments for running GeoAware and Mast3r. We have tested on Ubuntu 20.04.

1. Create the Tether conda environment with:
    ```
    conda create -n tether python=3.10
    conda activate tether
    pip install -r requirements.txt
    ```

2. Set up the GeoAware conda environment with the instructions [here](https://github.com/Junyi42/GeoAware-SC?tab=readme-ov-file#environment-setup). Change the `<path_to_GeoAware-SC>` [here](https://github.com/tether-research/tether/blob/d29ecd02ceac7ae6635959007471206a8bbb8e77/serve_geo_aware.py#L24) to the location you clone the GeoAware-SC repository.

3. Set up the MASt3R conda environment with the instructions [here](https://github.com/naver/mast3r).

4. Install our [Eva](https://github.com/willjhliang/eva) Franka infra, or prepare your own (more details below).

# Usage
1. Set your Gemini API key in `conf/config.yaml` under the `api_key_smart` and `api_key_fast` fields.

2. Collect the initial set of demonstrations for your target tasks. Place your demonstrations under `data_real/demos`.

We expect the following structure for demonstrations:
```
{demo_dir}/
  ├── trajectory.npz          # Has "state" representing the robot's Cartesian End Effector Pose
  ├── calibration.json        # Camera calibration; keyed by "{camera_id}_left"
  │                           # each entry has "extrinsics" (euler angles) and "intrinsics"
  └── recordings/
      └── {camera_name}.mp4   # One video per camera in cfg.setting.cameras
  └── recordings/
      └── frames/             # One folder of frames per camera in cfg.setting.cameras
          └── {camera_name}/
              └── 00000.jpg
              └── 00001.jpg
              ...
          └── {camera_name2}/
          ...
      └── {camera_name}.mp4   # One video per camera in cfg.setting.cameras
      ...
```
3. Edit the demo_names list in the `conf/setting/real.yaml` configuration to match your demonstration set. The format of this list is: `<name of the subdirectory in demo folder>`: `<desired natural instruction for Gemini action planning and success evaluation>`

4. In `conf/setting/real.yaml`, modify the camera parameters to be the ZED camera serial numbers in your setup. You can find the serial numbers for your cameras using [these instructions](https://support.stereolabs.com/hc/en-us/articles/19540095753111-How-can-I-get-the-serial-number-of-my-camera).

5. Adjust the `oob_bounds` parameters to the desired workspace in your scene. If the robot exceeds the desired workspace parameters during the execution of a trajectory, it will stop.

6. If using Eva, update the ip address in `robot_utils.py` to the Eva machine's ip. Otherwise, implement `collect_scene_image()` and `send_trajectory()` in `robot_utils.py` following your robot infra.

# Running the Policy

1. In the respective conda environments from the last section, start the servers for GeoAware and Mast3r by running `serve_geoaware.py` and `serve_mast3r.py`. Wait for the servers to both print Serving ... before proceeding.

2. Start the Eva server and runner [here](https://github.com/willjhliang/eva?tab=readme-ov-file#startup), or prepare your own robot infra.

3. To generate a single rollout, run `python runner.py mode=single action=<Name of action from setting config>`. This will select a random demo for your specified action and warp it for the current scene. The rollout data will be saved under `data_real/runs/<run_name>/rollouts_single`.

4. To run the autonomous play procedure, run `python runner.py mode=cycle`. This will begin by preprocessing the demos into the action library. It then will will run a cycle of action selection with the VLM, executing the selected action using Tether, and success evaluation using the VLM. The rollout data will be saved under `data_real/runs/<run_name>/rollouts_cycle`.

## Acknowledgements
We thank the following open-sourced projects:
* We compute correspondences using [GeoAware-SC](https://github.com/Junyi42/GeoAware-SC) and [MASt3R](https://github.com/naver/mast3r).
* Our deployment infrastructure, [Eva](https://github.com/willjhliang/eva), builds on [DROID](https://droid-dataset.github.io/droid/docs/software-setup)'s software setup.

# License
This codebase is released under [MIT License](LICENSE).

## Citation
```bibtex
@misc{liang2026tether,
      title={Tether: Autonomous Functional Play with Correspondence-Driven Trajectory Warping}, 
      author={William Liang and Sam Wang and Hung-Ju Wang and Osbert Bastani and Yecheng Jason Ma and Dinesh Jayaraman},
      year={2026},
      eprint={2603.03278},
      archivePrefix={arXiv},
      primaryClass={cs.RO},
      url={https://arxiv.org/abs/2603.03278}, 
}
```
