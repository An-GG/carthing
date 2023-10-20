
using inventor to refine a 3d scan from the TrueDepth camera on an iPhone XS using Heges


for some reason you need to download this random Add In and enable it in Inventor
```
https://apps.autodesk.com/INVNTOR/en/Detail/Index?id=6950391119076900441&appLang=en&os=Win64
```

now you can right click on the mesh in a new part and click "convert to base feature", change it to Solid/Surface and click ok


```
https://youtu.be/2sSX5-SFbkQ?si=VjsjXH4zEkVEpWXu
```

![nvidia_taskmanager_screenshot](nvidia_taskmanager_screenshot.jpg)

nice it has gpu accel mayb

![gpu0](gpu0.png)

nvm

---

time to give up


![whatever](whatever.png)

low poly 3d scan made in meshlab
- should've prob used rear lidar from the beginning, would've preserved scale

whatever

---

Reality Composer is unexpectedly trash at icp, damn <br>
(iphone 14 pro max / ipad pro fall 2022) 

![scan_scuffed1](scan_scuffed1.jpg)

![scan_scuffed1](scan_scuffed2.jpg)

prob useful for scale alignment in post

---

incredible scan detail from heges app

![shape_rotation](shape_rotation.gif)



---


## aight so heres the scan -> usable model geometry workflow 


need to clean up raw scan by cropping to desired volume (heges OBJ export iphone xs) **for now i used fusion but need fully offline toolchain for this bc mesh shit slow in fusion especially**



https://github.com/An-GG/carthing/assets/20458990/f1ebc4c7-1d2f-47df-9801-30fe4f20e267

cropping ->

![crop_in_fusion](https://github.com/An-GG/carthing/assets/20458990/52974401-fce6-4649-9b6d-51f13be56fa9)

---

too much data still, **so apparently there's a single obvious correct software for simplifying hi-res meshes** 

**do NOT fuck with meshlab, use this shit:** 

```
https://github.com/wjakob/instant-meshes?tab=readme-ov-file
```

**"Instant Mesher"**

![image](https://github.com/An-GG/carthing/assets/20458990/9900da56-67de-476b-8ebe-e0a63d3735a7)


---


 
k now we can do one of three things:

## A:

 - upload the OBJ to fusion and use convert to mesh **note: the obj will turn into it's own part that contains the mesh, you need the mesh to be in to be a body in your current open part or it wont let you do it for some stupid reason.** copy paste it to the parent part
![fusion_convert_to_mersh_menu](https://github.com/An-GG/carthing/assets/20458990/c227b829-312f-41e6-ba98-a6290c55ebd1)

![fusion_copy_mesh_to_root](https://github.com/An-GG/carthing/assets/20458990/0e8ba7b4-1599-487e-8094-6fab8a7b954c)

## B:

- import trimmed OBJ into Blender, delete default cube (important), and use "Solidify" to thicken the surface of the scan by like 0.1 mm or something
  - blender is pretty fast with this. export as OBJ

![blender_thicken](https://github.com/An-GG/carthing/assets/20458990/b819fa74-9168-4470-9f92-91055b30d027)


- import OBJ into autodesk inventor and use "convert to base feature" (need that Add In mentioned at the top of this doc)
  - save and export the entire thing as ipt, import ipt into fusion OR
  - export STL/**STEP**
 
> **This is by far the best method even though it seems kinda scuffed** and messy to just thicken the mesh bc you can immediately use the surfece geometry in 3d modeling software that has 0 support for mesh surfaces. (important rn, state of 3d scan support in the industry is dogshit)

<img width="1622" alt="shapr3d_doesnt_support_mesh" src="https://github.com/An-GG/carthing/assets/20458990/0e4c4024-e55d-4821-817d-e114be7c2317">

## C: 

- import OBJ into inventor, "convert to base feature", import ipt into fusion
  - i think this lets you use the mesh as a surface to define extrude extents/whatever *without doing the 'convert to mesh' step in fusion
