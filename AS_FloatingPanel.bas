﻿B4i=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
#If Documentation
Updates
V1.00
	-Release
V1.01
	-Add New OpenOrientations
		-OpenOrientation_None
			-Opens the panel without slide, but with fade
		-OpenOrientation_LeftTop
			-Opens the panel from left to top
		-OpenOrientation_RightTop
			-Opens the panel from right to top
		-OpenOrientation_LeftRight
			-Opens the panel from left to right
		-OpenOrientation_RightLeft
			-Opens the panel from right to left
		-OpenOrientation_TopBottom
			-Opens the panel from top to bottom
		-OpenOrientation_BottomTop
			-Opens the panel from bottom to top
	-Add Arrow
	-Add Type ASFloatingPanel_ArrowProperties
V1.02
	-BugFixes
V1.03
	-BugFixes
	-Add get and set CloseOnTap
		-Default: True
V1.04
	-BugFix
V1.05
	-Add get and set CornerRadius
		-Default: 10dip
V1.06
	-B4J BugFix
V1.07
	-BugFix - The function "Close" works now with CloseOnTap = False
V1.08
	-B4I Improvements - the entire screen is now used for the background shadow
		-When the navigation bar was hidden, there was an area at the top that did not go dark when the menu was opened
		-The height of the area is now determined and the gap closed
		-B4XPages is now required in B4I
#End If
#Event: Close

Sub Class_Globals
	
	Type ASFloatingPanel_ArrowProperties(ArrowOrientation As String,Color As Int,Width As Float,Height As Float,Left As Float,Top As Float)
	
	Private g_ArrowProperties As ASFloatingPanel_ArrowProperties
	
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private xui As XUI
	Private xpnl_Parent As B4XView
	Private xpnl_Background As B4XView
	Private xpnl_tmp As B4XView
	Private xpnl_Panel As B4XView
	Private xpnl_Arrow As B4XView
	
	Private m_OpenOrientation As String
	Private m_Duration As Long
	Private m_ArrowVisible As Boolean = False
	Private m_CloseOnTap As Boolean = True
	Private m_CornerRadius As Float = 10dip
	Private m_TopBarOffset As Float = 0
	
	Public BackgroundColor As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Callback As Object, EventName As String,Parent As B4XView)
	mEventName = EventName
	mCallBack = Callback
	xpnl_Parent = Parent
	m_OpenOrientation = getOpenOrientation_LeftBottom
	m_Duration = 150
	BackgroundColor = xui.Color_ARGB(152,0,0,0)
	xpnl_Panel = xui.CreatePanel("")
	
	xpnl_tmp = xui.CreatePanel("")
	Parent.AddView(xpnl_tmp,-10000dip,0,0,0)
	xpnl_tmp.AddView(xpnl_Panel,-10000dip,0,0,0)
	
	g_ArrowProperties = CreateASFloatingPanel_ArrowProperties(getArrowOrientation_Top,xui.Color_ARGB(255,32, 33, 37),20dip,10dip,-1,-1)
End Sub

Public Sub PreSize(Width As Float,Height As Float)
	xpnl_tmp.SetLayoutAnimated(0,-10000dip,0,Width,Height)
	xpnl_Panel.SetLayoutAnimated(0,0dip,0,Width,Height)
End Sub

Public Sub Show(Left As Float,Top As Float,Width As Float,Height As Float)
	#If B4J
	Sleep(200)
	#End If
	xpnl_tmp.RemoveViewFromParent
	
	#If B4I
	m_TopBarOffset = B4XPages.GetNativeParent(B4XPages.GetManager.GetTopPage.B4XPage).RootPanel.Top
	#End If
	
	Top = Top + m_TopBarOffset
	
	xpnl_Background = xui.CreatePanel("xpnl_Background")
	xpnl_Parent.AddView(xpnl_Background,0,-m_TopBarOffset,xpnl_Parent.Width,xpnl_Parent.Height + m_TopBarOffset)
	xpnl_Background.Color = BackgroundColor
	
	xpnl_Panel.RemoveViewFromParent
	xpnl_Background.AddView(xpnl_Panel,Left,Top,0,0)
	
	If m_OpenOrientation = getOpenOrientation_LeftBottom Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,Left,Top,Width,Height)
	Else If m_OpenOrientation = getOpenOrientation_RightBottom Then
		xpnl_Panel.Left = xpnl_Panel.Left + Width
		xpnl_Panel.SetLayoutAnimated(m_Duration,Left,Top,Width,Height)
	Else If m_OpenOrientation = getOpenOrientation_None Then
		xpnl_Panel.SetLayoutAnimated(0,Left,Top,Width,Height)
	Else If m_OpenOrientation = getOpenOrientation_LeftTop Then
		xpnl_Panel.Top = Top + Height
		xpnl_Panel.SetLayoutAnimated(m_Duration,Left,Top,Width,Height)
	Else If m_OpenOrientation = getOpenOrientation_RightTop Then
		xpnl_Panel.Top = Top + Height
		xpnl_Panel.Left = Left + Width
		xpnl_Panel.SetLayoutAnimated(m_Duration,Left,Top,Width,Height)
	Else If m_OpenOrientation = getOpenOrientation_LeftRight Then
		xpnl_Panel.Top = Top
		xpnl_Panel.Height = Height
		xpnl_Panel.SetLayoutAnimated(m_Duration,Left,Top,Width,Height)
	Else If m_OpenOrientation = getOpenOrientation_RightLeft Then
		xpnl_Panel.Top = Top
		xpnl_Panel.Left = Left + Width
		xpnl_Panel.Height = Height
		xpnl_Panel.SetLayoutAnimated(m_Duration,Left,Top,Width,Height)
	Else If m_OpenOrientation = getOpenOrientation_TopBottom Then
		xpnl_Panel.Top = Top
		xpnl_Panel.Width = Width
		xpnl_Panel.SetLayoutAnimated(m_Duration,Left,Top,Width,Height)
	Else If m_OpenOrientation = getOpenOrientation_BottomTop Then
		xpnl_Panel.Top = Top + Height
		xpnl_Panel.Width = Width
		xpnl_Panel.SetLayoutAnimated(m_Duration,Left,Top,Width,Height)
	End If
	
	xpnl_Panel.SetColorAndBorder(xui.Color_ARGB(255,32, 33, 37),0,0,m_CornerRadius)
	SetCircleClip(xpnl_Panel,m_CornerRadius)
	
	Sleep(m_Duration)
	
	If m_ArrowVisible Then
		
		xpnl_Arrow = xui.CreatePanel("")
		xpnl_Arrow.Color = xui.Color_Transparent
		xpnl_Background.AddView(xpnl_Arrow,xpnl_Panel.Left + g_ArrowProperties.Width,xpnl_Panel.Top - g_ArrowProperties.Height,g_ArrowProperties.Width,g_ArrowProperties.Height)
		
		Dim xCV As B4XCanvas
		xCV.Initialize(xpnl_Arrow)
		
		xCV.ClearRect(xCV.TargetRect)
		Dim p As B4XPath
		
		Select g_ArrowProperties.ArrowOrientation
			Case getArrowOrientation_Top
				'p.Initialize(xpnl_Arrow.Width / 2, 0).LineTo(xpnl_Arrow.Width, xpnl_Arrow.Height).LineTo(0, xpnl_Arrow.Height).LineTo(xpnl_Arrow.Width / 2, 0)
				
				p.Initialize(xpnl_Arrow.Width/2,0).LineTo(0,xpnl_Arrow.Height).LineTo(xpnl_Arrow.Width,xpnl_Arrow.Height).LineTo(xpnl_Arrow.Width/2,0)
				
				xpnl_Arrow.SetLayoutAnimated(0,xpnl_Panel.Left + g_ArrowProperties.Left,xpnl_Panel.Top - g_ArrowProperties.Height + g_ArrowProperties.Top,g_ArrowProperties.Width,g_ArrowProperties.Height)
			Case getArrowOrientation_Bottom
				p.Initialize(0, 0).LineTo(xpnl_Arrow.Width, 0).LineTo(xpnl_Arrow.Width / 2, xpnl_Arrow.Height).LineTo(0, 0)
				xpnl_Arrow.SetLayoutAnimated(0,xpnl_Panel.Left + g_ArrowProperties.Left,xpnl_Panel.Top + xpnl_Panel.Height,g_ArrowProperties.Width,g_ArrowProperties.Height)
			Case getArrowOrientation_Right
				p.Initialize(xpnl_Arrow.Width/2,0).LineTo(0,xpnl_Arrow.Height).LineTo(xpnl_Arrow.Width,xpnl_Arrow.Height).LineTo(xpnl_Arrow.Width/2,0)
				xpnl_Arrow.SetLayoutAnimated(0,xpnl_Panel.Left + xpnl_Panel.Width - g_ArrowProperties.Height/2,xpnl_Panel.Top + g_ArrowProperties.Top,g_ArrowProperties.Width,g_ArrowProperties.Height)
				xpnl_Arrow.Rotation = 90
			Case getArrowOrientation_Left
				
				p.Initialize(xpnl_Arrow.Width/2,0).LineTo(0,xpnl_Arrow.Height).LineTo(xpnl_Arrow.Width,xpnl_Arrow.Height).LineTo(xpnl_Arrow.Width/2,0)
				xpnl_Arrow.SetLayoutAnimated(0,xpnl_Panel.Left - g_ArrowProperties.Width + g_ArrowProperties.Height/2,xpnl_Panel.Top + g_ArrowProperties.Top,g_ArrowProperties.Width,g_ArrowProperties.Height)
				xpnl_Arrow.Rotation = -90
		End Select
		
		xCV.DrawPath(p, g_ArrowProperties.Color, True, 0)
		xCV.Invalidate
		
	End If
	
	'xpnl_Panel.As(Panel).UserInteractionEnabled = True
	
End Sub

#If B4J
Private Sub xpnl_Background_MouseClicked (EventData As MouseEvent)
#Else
Private Sub xpnl_Background_Click
#End If
	CloseIntern(False)
End Sub

Public Sub Close
	CloseIntern(True)
End Sub

Private Sub CloseIntern(Force As Boolean)
	If m_CloseOnTap = False And Force = False Then Return
	EventClose
	If m_ArrowVisible Then xpnl_Arrow.SetVisibleAnimated(0,False)
	xpnl_Background.SetVisibleAnimated(250,False)
	
	If m_OpenOrientation = getOpenOrientation_LeftBottom Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,xpnl_Panel.Left,xpnl_Panel.Top,1dip,1dip)
	Else If m_OpenOrientation = getOpenOrientation_RightBottom Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,xpnl_Panel.Left + xpnl_Panel.Width,xpnl_Panel.Top,1dip,1dip)
	Else If m_OpenOrientation = getOpenOrientation_LeftTop Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,xpnl_Panel.Left,xpnl_Panel.Top + xpnl_Panel.Height,1dip,1dip)
	Else If m_OpenOrientation = getOpenOrientation_RightTop Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,xpnl_Panel.Left + xpnl_Panel.Width,xpnl_Panel.Top + xpnl_Panel.Height,1dip,1dip)
	Else If m_OpenOrientation = getOpenOrientation_LeftRight Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,xpnl_Panel.Left,xpnl_Panel.Top,1dip,xpnl_Panel.Height)
	Else If m_OpenOrientation = getOpenOrientation_RightLeft Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,xpnl_Panel.Left + xpnl_Panel.Width,xpnl_Panel.Top,1dip,xpnl_Panel.Height)
	Else If m_OpenOrientation = getOpenOrientation_TopBottom Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,xpnl_Panel.Left,xpnl_Panel.Top,xpnl_Panel.Width,1dip)
	Else If m_OpenOrientation = getOpenOrientation_BottomTop Then
		xpnl_Panel.SetLayoutAnimated(m_Duration,xpnl_Panel.Left,xpnl_Panel.Top + xpnl_Panel.Height,xpnl_Panel.Width,1dip)
	End If
	
	Sleep(250)
	xpnl_Background.RemoveViewFromParent
End Sub

'Default: 10dip
Public Sub getCornerRadius As Float
	Return m_CornerRadius
End Sub

Public Sub setCornerRadius(Radius As Float)
	m_CornerRadius = Radius
	xpnl_Panel.SetColorAndBorder(xpnl_Panel.Color,0,0,Radius)
	SetCircleClip(xpnl_Panel,Radius)
End Sub

Public Sub getCloseOnTap As Boolean
	Return m_CloseOnTap
End Sub

Public Sub setCloseOnTap(Enabled As Boolean)
	m_CloseOnTap = Enabled
End Sub

Public Sub getPanel As B4XView
	Return xpnl_Panel
End Sub

Public Sub setOpenOrientation(Orientation As String)
	m_OpenOrientation = Orientation
End Sub
'Default: 150
Public Sub setDuration(Duration As Long)
	m_Duration = Duration
End Sub

Public Sub getArrowVisible As Boolean
	Return m_ArrowVisible
End Sub

Public Sub setArrowVisible(Visible As Boolean)
	m_ArrowVisible = Visible
End Sub

Public Sub getArrowProperties As ASFloatingPanel_ArrowProperties
	Return g_ArrowProperties
End Sub

Public Sub setArrowProperties(Properties As ASFloatingPanel_ArrowProperties)
	g_ArrowProperties = Properties
End Sub

Private Sub SetCircleClip (pnl As B4XView,radius As Int)'ignore
#if B4J
	Dim jo As JavaObject = pnl
	Dim shape As JavaObject
	Dim cx As Double = pnl.Width
	Dim cy As Double = pnl.Height
	shape.InitializeNewInstance("javafx.scene.shape.Rectangle", Array(cx, cy))
	If radius > 0 Then
		Dim d As Double = radius
		shape.RunMethod("setArcHeight", Array(d))
		shape.RunMethod("setArcWidth", Array(d))
	End If
	jo.RunMethod("setClip", Array(shape))
#else if B4A
	Dim jo As JavaObject = pnl
	jo.RunMethod("setClipToOutline", Array(True))
	pnl.SetColorAndBorder(pnl.Color,0,0,m_CornerRadius)
	#Else
	pnl.SetColorAndBorder(pnl.Color,0,0,m_CornerRadius)
#end if
End Sub

#Region Enums
'Opens the panel without slide, but with fade
Public Sub getOpenOrientation_None As String
	Return "None"
End Sub
'Opens the panel from left to bottom
Public Sub getOpenOrientation_LeftBottom As String
	Return "LeftBottom"
End Sub
'Opens the panel from right to bottom
Public Sub getOpenOrientation_RightBottom As String
	Return "RightBottom"
End Sub
'Opens the panel from left to top
Public Sub getOpenOrientation_LeftTop As String
	Return "LeftTop"
End Sub
'Opens the panel from right to top
Public Sub getOpenOrientation_RightTop As String
	Return "RightTop"
End Sub
'Opens the panel from left to right
Public Sub getOpenOrientation_LeftRight As String
	Return "LeftRight"
End Sub
'Opens the panel from right to left
Public Sub getOpenOrientation_RightLeft As String
	Return "RightLeft"
End Sub
'Opens the panel from top to bottom
Public Sub getOpenOrientation_TopBottom As String
	Return "TopBottom"
End Sub
'Opens the panel from bottom to top
Public Sub getOpenOrientation_BottomTop As String
	Return "BottomTop"
End Sub


'The Arrow is on the top of the panel
Public Sub getArrowOrientation_Top As String
	Return "Top"
End Sub
'The Arrow is on the bottom of the panel
Public Sub getArrowOrientation_Bottom As String
	Return "Bottom"
End Sub
'The Arrow is on the lft of the panel
Public Sub getArrowOrientation_Left As String
	Return "Left"
End Sub
'The Arrow is on the right of the panel
Public Sub getArrowOrientation_Right As String
	Return "Right"
End Sub

#End Region

#Region Events

Private Sub EventClose
	If xui.SubExists(mCallBack, mEventName & "_Close", 0) Then
		CallSub(mCallBack, mEventName & "_Close")
	End If
End Sub

#End Region

Public Sub CreateASFloatingPanel_ArrowProperties (ArrowOrientation As String, Color As Int, Width As Float, Height As Float, Left As Float, Top As Float) As ASFloatingPanel_ArrowProperties
	Dim t1 As ASFloatingPanel_ArrowProperties
	t1.Initialize
	t1.ArrowOrientation = ArrowOrientation
	t1.Color = Color
	t1.Width = Width
	t1.Height = Height
	t1.Left = Left
	t1.Top = Top
	Return t1
End Sub