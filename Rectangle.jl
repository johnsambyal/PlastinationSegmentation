using GLMakie, FileIO
using AbstractPlotting
using Images, ImageSegmentation

#Loading the sample image of dimension 370 x 370
img = load("sample_small_original.png")

#Creating the scene with any given resolution
scene = Scene(resolution = (800, 800))

#Plotting the image onto the scene
image!(scene, img, scale_plot = false)

#Initializing the points node
points = Node(zeros(Point2f0, 100))

#Initiliazing the starting point and the ending point of the rectangle as nodes
pos1 = Node(zeros(Point2f0, 100))
pos2 = Node(zeros(Point2f0, 100))

#Initializing the index counter
last_idx = Ref(0)

#Creating an event for a mouse drag
on(scene.events.mousedrag) do drag
    if ispressed(scene, Mouse.left) #Mouse event on left mouse click button
        last_idx[] += 1
        if drag == Mouse.down #When the left mouse click is pressed down
            select_rectangle(scene) #Creating the rectangle
            pos = mouseposition(scene) #Capturing the coordinates of the mouse at the button press
            pos1[][last_idx[]] = pos #Updating the point 1 node
        elseif drag == Mouse.pressed
            pos = mouseposition(scene)
            pos2[][last_idx[]] = pos #Updating the point 2 node
        end
    end
end

#Creating an event for keyboard button 'g' for carrying out the ImageSegmentation
on(scene.events.keyboardbuttons) do keys
    if ispressed(scene, Keyboard.g) #When keyobard button g is pressed
        #Getting the rounded integer values for x1, x2, y1 and y2
        x1 = Int(round(pos1[][1][1])) 
        y1 = Int(round(pos1[][1][2]))
        x2 = Int(round(pos2[][last_idx[]][1]))
        y2 = Int(round(pos2[][last_idx[]][2]))

        println("x1 = ", x1, ", y1 = ", y1, ", x2 = ", x2, ", y2 = ", y2)

        #Creating a duplicate of the image
        img2 = RGB.(img)
        #Carrying out a simple felzenszwalb segmentation to test the interativity 
        segments = felzenszwalb(img2[x1:x2, y1:y2], 10)
        #Mapping the segments to the image
        img3 = map(i->segment_mean(segments,i), labels_map(segments))
        #Replacing the rectangle in the original image with the segmented pixels
        img2[x1:x2, y1:y2] = img3
        #Displaying the final image
        image!(scene, img2, scale_plot = false)
    end
end

scene
