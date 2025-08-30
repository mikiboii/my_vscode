git clone https://github.com/sczhou/CodeFormer.git
cd CodeFormer

# apt-get install -y libgl1 libglib2.0-0 ffmpeg libsm6 libxext6

sudo apt update

sudo apt install -y libgl1-mesa-glx libglib2.0-0 ffmpeg libsm6 libxext6


# Install Python and pip if missing
sudo apt install -y python3 python3-pip python3.11-venv



python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate


pip install -r requirements.txt
python basicsr/setup.py develop

python scripts/download_pretrained_models.py facelib
python scripts/download_pretrained_models.py CodeFormer

# Upload your video file using the files tab
# Then run:
python inference_codeformer.py --bg_upsampler realesrgan --face_upsample -w 0.7 --input_path Comp_1.mp4


python inference_codeformer.py --input_path img_1.jpg -w 0.7 --bg_upsampler realesrgan