B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=9.3
@EndOfDesignText@
Sub Process_Globals
	Private xui As XUI
End Sub



Sub Load_Image(iv As ImageView, folderName As String, fileName As String)
	iv.Bitmap = Null
	iv.SetBackgroundImage(LoadBitmapResize(folderName, fileName, iv.Width, iv.Height, True)).Gravity = Gravity.CENTER
End Sub


Sub Round_Image (iv As ImageView, folderName As String, fileName As String)
	iv.Bitmap = Null
	Private bm As Bitmap = LoadBitmapResize(folderName, fileName, iv.Width, iv.Height, True)
	If bm.Width <> bm.Height Then
		Dim l As Int = Min(bm.Width, bm.Height)
		bm = bm.Crop(bm.Width / 2 - l / 2, bm.Height / 2 - l / 2, l, l)
	End If
	Dim c As B4XCanvas
	Dim xview As B4XView = xui.CreatePanel("")
	xview.SetLayoutAnimated(0, 0, 0, iv.Width, iv.Width)
	c.Initialize(xview)
	Dim path As B4XPath
	path.InitializeOval(c.TargetRect)
	c.ClipPath(path)
	c.DrawBitmap(bm.Resize(iv.Width, iv.Width, False), c.TargetRect)
	c.RemoveClip
	c.DrawCircle(c.TargetRect.CenterX, c.TargetRect.CenterY, c.TargetRect.Width / 2 - 2dip, xui.Color_White, False, 5dip)
	c.Invalidate
	c.Release
	iv.SetBackgroundImage(c.CreateBitmap.Resize(iv.Width,iv.Height,True)).Gravity = Gravity.CENTER
	bm = Null
End Sub


Sub Center_Image(iv As ImageView, folderName As String, fileName As String)
	iv.Bitmap = Null
	Private bm As Bitmap = LoadBitmapResize(folderName, fileName, iv.Width, iv.Height, True)
	Private cvs As Canvas
	cvs.Initialize(iv)
	Dim rectDest As Rect
	Dim delta As Int
	If bm.Width / bm.Height > iv.Width / iv.Height Then
		delta = (iv.Width - bm.Width / bm.Height * iv.Height) / 2
		rectDest.Initialize(delta, 0, iv.Width - delta, iv.Height)
	Else
		delta = (iv.Height - bm.Height / bm.Width * iv.Width) / 2
		rectDest.Initialize(0, delta,iv.Width, iv.Height - delta)
	End If
	cvs.DrawBitmap(bm, Null, rectDest)
	iv.Invalidate
	bm = Null
End Sub


Public Sub Get_AllTabLabels (tabstrip As TabStrip) As List
	Dim jo As JavaObject = tabstrip
	Dim r As Reflector
	r.Target = jo.GetField("tabStrip")
	Dim tc As Panel = r.GetField("tabsContainer")
	Dim res As List
	res.Initialize
	For Each v As View In tc
		If v Is Label Then res.Add(v)
	Next
	Return res
End Sub



Sub Set_StatusBarColor(clr As Int)
	Dim p As Phone
	If p.SdkVersion >= 21 Then
		Dim jo As JavaObject
		jo.InitializeContext
		Dim window As JavaObject = jo.RunMethodJO("getWindow", Null)
		window.RunMethod("addFlags", Array (0x80000000))
		window.RunMethod("clearFlags", Array (0x04000000))
		window.RunMethod("setStatusBarColor", Array(clr))
	End If
End Sub