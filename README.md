# Dynamic Gaussian Marbles for Novel View Synthesis of Casual Monocular Videos

This is the official implementation for the SIGGRAPH Asia 2024 paper **Dynamic Gaussian Marbles for Novel View Synthesis of Casual Monocular Videos**. [[Paper](https://arxiv.org/pdf/2406.18717)] [[Project Page](https://geometry.stanford.edu/projects/dynamic-gaussian-marbles.github.io/)]
![DGMarbles Teaser](media/teaser.jpg)

## Installation

> This code has been tested on Ubuntu 20.04 with Python 3.10, CUDA 11.7, and PyTorch 2.0.1.

> This code DOES NOT work with CUDA 12.X due to its dependency on the [FRNN](https://github.com/lxxue/FRNN) package.


#### Step 1: Create a Python Environment

We recommend using a conda environment. Create an environment `dgmarbles`:

```bash
conda create -n dgmarbles python=3.10
conda activate dgmarbles
```

**Step 2: Install Dependencies**

The `setup.sh` script installs all necessary dependencies. Simply pass in the location
of the anaconda base directory as well as the "dgmarbles" environment name:

```bash
bash setup.sh <path_to_conda_env> dgmarbles
```

For example, `bash setup.sh ~/anaconda3 dgmarbles`


**Notes:**
* We assume CUDA 11.7. For other CUDA versions,  you may need to adjust `setup.sh` accordingly.
* We assume a standard Linux system with `apt-get` available. If not using Linux, you may need to adjust the script accordingly.
* Our environment builds off of [NerfStudio](https://github.com/nerfstudio-project/nerfstudio), which, among other things, allows interactive visualization
* Our environment assumes the use of [Weight and Biases (wandb)](https://wandb.ai/site). If you do not wish to use wandb, please set the flag `WANDB_MODE=offline` before running code.



## Data

### Downloading Data
We provide processed datasets that are ready-to-use in the form of zip files.

| Dataset                    | Google Drive URL                                                                                            | PSNR / LPIPs  |  
|----------------------------|-------------------------------------------------------------------------------------------------------------|---------------|
| DyCheck IPhone (with pose) | [here](https://drive.google.com/drive/folders/1K3YSRNx9j7u_Sq86Y1mpqXl7Z2bMvyhE?usp=drive_link)             | 16.72 / 0.418 |              
| DyCheck IPhone (no pose)   | [here](https://drive.google.com/drive/folders/1cJGkFYPTT4UzSrSlHS6oPhha1bHSaBpn?usp=drive_link)             | 15.79 / 0.428 |              
| Monocular Nvidia           | [here](https://drive.google.com/drive/folders/1ohVeRHTxd2m6VgMAT5zPXBfjLqRxPtLJ?usp=drive_link)             | 22.32 / 0.129 |               
| Total-Recon                | Coming soon!                                                                                                | -- / 0.376    |               
| Davis                      | Coming soon!                                                                                                | NA / NA       |             
| YouTube-VOS                | [here](https://drive.google.com/drive/folders/1zZGeXNkGs77uK8c3J2oZZPabH1JxWrc2?usp=drive_link)             | NA / NA       |            
| Real World                 | Coming soon!                                                                                                | NA / NA       |   

Download each dataset and place the unzipped folder in the `data/` directory. For instance, the Nvidia Dynamic Scenes dataset 
would look like:
```
data
└── nvidia
    └── Balloon1/
    └── Balloon2/
    └── ...
    └── Umbrella/

```

### Data Format

Each of our scenes generally follows the [Nerfies](https://nerfies.github.io/) directory format. However, there are a few 
meaningful additions, including depth, segmentation, and tracking. We illustrate our data directory structure below:

**Minimal Data Directory Structure:**

```
scene_datadir
├── camera
│   └── C_XXXXX.json
│   └── ...
├── rgb
│   └── 1x
│       ├── C_XXXXX.png
│       └── ...
├── depth
│   └── 1x
│       ├── C_XXXXX.npy
│       └── ...
├── segmentation
│   └── 1x
│       ├── C_XXXXX.npy
│       └── ...
├── tracks
│   └── 1x
│       ├── track_XXXXX.npy
│       └── ...
└── splits
│   ├── train.json
│   └── val.json
│── scene.json
└── dataset.json 
```

**Details on Each Subdirectories:**

<details>
  <summary>Details</summary>

* `C` and `XXXXX` represent the camera ID and timestep ID respectively
* **`camera`:** Contains JSON files for each camera's intrinsics  and extrinsics.
* **`rgb`:**  Contains RGB images for each camera view and timestep.
* **`depth`:**  Stores metric depth maps as NumPy (`.npy`) files. 
* **`segmentation`:** Contains per-frame segmentation masks (`.npy`).
* **`tracks`:**  Stores sparse CoTracker trajectories (`.npy`) originating from this frame. 
* **`splits`:** Defines the training and validation splits (.json).
* **`scene.json`:** A JSON file defining scene-specific parameters like center, scale, near, and far clipping planes.
* **`dataset.json`:** A JSON file providing dataset-level information like the number of images and image names.
</details>

### Running on Your Own Monocular Videos
Coming soon!


## Evaluating Pretrained Models

### Downloading Checkpoints

We provide the optimized Dynamic Gaussian Marbles for each scene reported in the paper  [here](https://drive.google.com/drive/folders/1k6h3it389Oc0D7qdeTSu2vFMo2bKoW4k?usp=drive_link). 
Please download the appropriate checkpoints, abd place them into a `checkpoints` directory.
Please make sure that each checkpoint is within its OWN subdirectory (as our code takes in a directory and searches for
checkpoints within the directory).

### Running Evaluation
Run the following command to perform evaluation with a downloaded checkpoint:
  ```bash
  python train.py --data_dir <data_dir> --config <config_file> --load_dir <checkpoint_directory> --outdir ./out --only_render True
  ```

For example, to evaluate and render the pretrained Nvidia Balloon1 scene, run:
  ```bash
  python train.py --data_dir ./data/nvidia/Balloon1 --config configs.dgmarbles_nvidia --load_dir ./checkpoints/balloon1 --outdir ./out --only_render True
  ```

##  Training

### Training on Existing Data
To reproduce our provided checkpoints, simply train on a dataset with the appropriate configuration file:
  ```bash
  python train.py --data_dir <data_dir> --config <config_file> --load_dir <checkpoint_directory> --outdir ./out --only_render True
  ```
For example, to train on the Nvidia Balloon1 scene, run:
  ```bash
  python train.py --data_dir ./data/nvidia/Balloon1 --config configs.dgmarbles_nvidia --outdir ./out
  ```

### Training on Your Own Data
Coming soon!


## Additional Training Arguments

To customize the training process, you can also pass the following arguments into the command line. 

**Example:**

```bash
python train.py --data_dir data/nvidia/Balloon1 --config configs.dgmarbles_nvidia --number_of_gaussians 100000 --tracking_loss_weight 0.5
```

**Arguments:**

<details>
  <summary>General Arguments</summary>

* **`--data_dir` (str, required):** Path to the dataset directory.
* **`--model_config` (str, required):** Path to the model configuration file.
* **`--output` (str, default: `./out`):** Path to the output directory.
* **`--load_dir` (str, default: `""`):** Path to the directory containing a pre-trained model checkpoint. 
* **`--only_render` (str, default: `False`):**  If "True", skip training and render using a pre-trained model specified in `--load_dir`.

</details>


<details>
  <summary>Learning Rates</summary>

* `--delta_position_lr` (float): Learning rate for updating motion offsets of Gaussians. 

</details>

<details>
  <summary>Training Algorithm</summary>

  * **`--number_of_gaussians` (int):** The number of Gaussian marbles used to represent the scene.
  * **`--frame_transport_dropout` (float):** Probability of dropping out Gaussians while training to prevent overfitting. 
  * **`--supervision_downscale` (int):** Factor for downscaling images during supervision (default: 1).  Larger values can reduce memory usage and training time.
  * **`--freeze_frames_of_origin` (str, default: `True`):** Prevents the model from learning motion for the frames where Gaussian marbles were initialized.  

</details>

<details>
  <summary>Background Parameters</summary>

  * **`--no_background` (str, default: `False`):**  If "True", models everything as foreground.
  * **`--static_background` (str, default: `False`):**  Assumes a static background, represented by a single set of Gaussians.
  * **`--render_background_probability` (float, default: 0.5):** Only valid when `static_background` is True. This is 
  the probability of rendering the static background  during training. A value of 1.0 always renders the background.

</details>

<details>
  <summary>Loss Weights</summary>

  * **`--isometry_loss_weight` (float):** Weight of the isometry loss, which encourages locally rigid motion of the Gaussians.
  * **`--chamfer_loss_weight` (float):** Weight of the Chamfer loss, encouraging 3D alignment of Gaussians.
  * **`--photometric_loss_weight` (float):** Weight of the photometric (L1) loss between the rendered image and the target image.
  * **`--tracking_loss_weight` (float):** Weight of the tracking loss, guiding the Gaussians to follow the 2D predicted tracks.
  * **`--segmentation_loss_weight` (float):** Weight of the segmentation loss, encouraging the model to render segmentations consistent with provided SAM predictions.
  * **`--velocity_smoothing_loss_weight` (float):**  Weight for the velocity smoothing loss, promoting smooth Gaussian trajectories.
  * **`--depthmap_loss_weight` (float):** Weight for the depth map loss. 
  * **`--instance_isometry_loss_weight` (float):** Weight of the instance isometry loss, promoting more rigid tracking motion of objects. 
  * **`--scaling_loss_weight` (float):**  Weight for the Gaussian scaling loss. This loss helps control the size of the Gaussians, preventing them from becoming too large.
  * **`--lpips_loss_weight` (float):**  Weight for the LPIPS loss, which measures the perceptual similarity between the rendered and target images.

</details>

<details>
  <summary>Merge Downsampling</summary>

  * **`--prune_points` (str, default: `True`):** Enables pruning of low-opacity and small-scale Gaussians after merging.
  * **`--downsample_reducescale` (float):**  Scales down the size of Gaussians after merging.

</details>

<details>
  <summary>Isometry Loss Parameters</summary>

  * **`--isometry_knn` (int):** Number of nearest neighbors used for calculating the isometry loss.
  * **`--isometry_knn_radius` (float):** Search radius for finding nearest neighbors for the isometry loss.
  * **`--isometry_per_segment` (str, default: `True`):** Computes the isometry loss separately for each segmentation class, ensuring isometry within objects.
  * **`--instance_isometry_numpairs` (int):** Number of Gaussian pairs sampled for computing the instance isometry loss. 
</details>

<details>
  <summary>Chamfer Loss Parameters</summary>

  * **`--chamfer_agg_group_ratio` (float):** Ratio of frames used when grouping them for Chamfer loss calculation.
</details>



<details>
  <summary>Tracking Loss Parameters</summary>

  * **`--tracking_knn` (int):**  Number of nearest Gaussians considered when associating them with keypoint tracks.
  * **`--tracking_radius` (int):** Search radius for finding nearest Gaussians to tracked keypoints.
  * **`--tracking_loss_per_segment` (str, default: `True`):** If "True", computes the tracking loss separately for each segmentation class.
  * **`--tracking_window` (int):** Size of the temporal window used for associating Gaussians with keypoint tracks.
</details>

<details>
  <summary>Data Parameters</summary>

  * **`--depth_remove_outliers` (str, default: `False`):** Removes outliers from the depth maps before generating the initial point cloud. 
  * **`--downscale_factor` (int):**  Downscaling factor for images, depth maps, and segmentation masks during data parsing.
</details>


## License and Citation

This project is licensed under the MIT License.

If you use this work, please cite:

```bibtex
@inproceedings{stearns2024marbles,
  title={Dynamic Gaussian Marbles for Novel View Synthesis of Casual Monocular Videos},
  author={Stearns, Colton and Harley, Adam W and Uy, Mikaela and Dubost, Florian and Tombari, Federico and Wetzstein, Gordon and Guibas, Leonidas},
  booktitle={SIGGRAPH Asia 2024 Conference Papers},
  pages={1--11},
  year={2024}
}
``` 