/*

Tool Description:

    Tool Name   : Pivot Normal Tool

    Description :

                1. Pivot - User can set Pivot for objects with many options like  select current Pivot and apply Same Pivot position to all other objects

    Author      : Manjunath N <manju.manju.v@gmail.com>

 

*/

try(
cui.unregisterdialogbar PivotNormal
destroydialog PivotNormal
) catch()

fn FnSetPivot obj =
(
	delta = [0,0,0]
	for verts in obj.selectedVerts do
		delta += verts.pos
	delta /= obj.selectedVerts.count
	obj.pivot = delta
	convertToPoly obj
)

fn customPivot val =
(
	Obj = $
	if (selection as array).count > 1 then        ( messagebox "Please select only one object" ) else
	(
		case val of
		(
			1: Obj.pivot = [Obj.pivot.x,Obj.pivot.y,Obj.max.z]
			2: Obj.pivot = [Obj.pivot.x,Obj.pivot.y,Obj.min.z]
			3: Obj.pivot = [Obj.min.x,Obj.pivot.y,Obj.pivot.z]
			4: Obj.pivot = ((Obj.max + Obj.min)/2)
			5: Obj.pivot = [Obj.max.x,Obj.pivot.y,Obj.pivot.z]
			6: Obj.pivot = [Obj.pivot.x,Obj.min.y,Obj.pivot.z]
			7: Obj.pivot = [Obj.pivot.x,Obj.max.y,Obj.pivot.z]
		)
	)

)

rollout PivotNormal "3DS Max - Pivot Tool" width:185 height:290

(

	button currentP "Current Pivot" pos:[16,12] width:152 height:33
	button topP "Top" pos:[8,51] width:80 height:24
	button bottomP "Bottom" pos:[96,51] width:80 height:24
	button leftP "Left" pos:[9,80] width:48 height:24
	button centerP "Center" pos:[64,80] width:56 height:24
	button rightP "Right" pos:[128,80] width:48 height:24
	button frontP "Front" pos:[8,110] width:80 height:24
	button backP "Back" pos:[96,110] width:80 height:24
	button sameP "Same Pivot to All" pos:[24,141] width:136 height:25
	button samePo "Pivot Origin (0,0,0)" pos:[10,172] width:165 height:25
	button resetXfor "Reset XForm" pos:[8,205] width:168 height:24
	groupBox uiOutline "" pos:[2,196] width:180 height:35
	groupBox uiOutline1 "-:- Extra Options -:-" pos:[2,240] width:180 height:45
	button hideBtn "Hide Selection" pos:[8,255] width:88 height:25
	button unhideBtn "Unhide All" pos:[98,255] width:80 height:25

   
	on currentP pressed do
	(
		if ((selection as array).count > 1 or (selection as array).count == 0) then ( messagebox "Please select only one object" ) else
		(
			case subobjectLevel of
			(
				2:$.ConvertSelection #Edge #Vertex
				3:$.ConvertSelection #Border #Vertex
				4:$.ConvertSelection #Face #Vertex
				5:$.ConvertSelection #Element #Vertex
			)
			if subobjectLevel == 0 or subobjectLevel == undefined then
				for i in selection do (i.pivot = ((i.max + i.min)/2))
			else(	FnSetPivot($))
		)

	)

	on topP pressed do customPivot (1)

	on bottomP pressed do customPivot (2)

	on leftP pressed do customPivot (3)

	on centerP pressed do customPivot (4)

	on rightP pressed do customPivot (5)

	on frontP pressed do customPivot (6)

	on backP pressed do customPivot (7)

	on hideBtn pressed do (max hide selection)

	on unhideBtn pressed do (max unhide all)

	on sameP pressed do
	(
		objList = selection as array
		valPiv = objList[1].pivot
		deleteItem objList 1
		for eachobj in objList do
			eachobj.pivot = valPiv
	)

	on samePo pressed do
	(
	for eachobj in (selection as array) do
		eachobj.pivot = [0,0,0]
	)
)

createdialog PivotNormal style:#(#style_toolwindow, #style_sysmenu)

cui.registerdialogbar PivotNormal
