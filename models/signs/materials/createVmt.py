import os
import subprocess


# Run VTFCmd command
subprocess.run(
    [
        "VTFCmd",
        "-folder",
        ".\\png\\",
        "-version",
        "7.3",
        "-output",
        r"P:\\team-fortress\\mvm_ascent\\tf\\materials\\models\\mvm_ascent\\sign",
    ],
    check=True,
)

# Define paths
valve_dir = "P:\\team-fortress\\mvm_ascent\\tf\\materials\\models\\mvm_ascent\\sign"
base_dir = os.path.dirname(os.path.abspath(__file__))
template_path = os.path.join(base_dir, "template.vmt")

# Read template content
with open(template_path, "r") as f:
    template_content = f.read()

# List only .vtf files in the valve subfolder
for filename in os.listdir(valve_dir):
    file_path = os.path.join(valve_dir, filename)
    if os.path.isfile(file_path) and filename.lower().endswith(".vtf"):
        name, _ = os.path.splitext(filename)

        # Replace all instances of "template" with the file name
        vmt_content = template_content.replace("template", name)
        new_vmt_path = os.path.join(valve_dir, f"{name}.vmt")
        with open(new_vmt_path, "w") as out_file:
            out_file.write(vmt_content)
