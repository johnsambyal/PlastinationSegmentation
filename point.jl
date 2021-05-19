using GLMakie, FileIO
using AbstractPlotting

#Loading the sample image of dimension 370 x 370
img = load("sample_small_original.png")

#Creating the scene with any given resolution
scene = Scene(resolution = (800, 800))

#Plotting the image onto the scene
image!(scene, img, scale_plot = false)

#Initializing the variables for the points and the color
#Nodes are used when working with interactive figures and plots
clicks = Node(zeros(Point2f0, 100))
colors = Node(zeros(RGBAf0, 100))

#Initializing index counter
last_idx = Ref(0)

#Creating an event that triggers on the click of the left mouse button
on(scene.events.mousebuttons) do button
    if ispressed(scene, Mouse.left)
        pos = mouseposition(scene) #Capturing the coordinates of the mouse at the button press
        last_idx[] += 1
        clicks[][last_idx[]] = pos #Updating the node based on the button press
        colors[][last_idx[]] = RGBAf0(1, 0, 0, 1) #updating the color
        clicks[] = clicks[]; colors[] = colors[]   
        
        println("The Coordinates are $pos") #This will give the coordinates of the selected pixel

        return 
    end
end

#Using scatter plot to display the click
scatter!(scene, clicks, color = colors, marker = '+', markersize = 10); 

#Running the scene
scene