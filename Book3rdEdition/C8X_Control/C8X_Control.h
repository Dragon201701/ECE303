
// C8X_Control.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CC8X_ControlApp:
// See C8X_Control.cpp for the implementation of this class
//

class CC8X_ControlApp : public CWinApp
{
public:
	CC8X_ControlApp();

// Overrides
public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CC8X_ControlApp theApp;