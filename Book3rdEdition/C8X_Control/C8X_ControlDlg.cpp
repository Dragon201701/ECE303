
// C8X_ControlDlg.cpp : implementation file
//

#include "stdafx.h"
#include "C8X_Control.h"
#include "C8X_ControlDlg.h"
#include "afxdialogex.h"
#include "afxwin.h"
#include "math.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAboutDlg dialog used for App About

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	virtual BOOL OnInitDialog();
	DECLARE_MESSAGE_MAP()
public:
	CEdit m_VersionText;
};

CAboutDlg::CAboutDlg() : CDialogEx(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_VersionText, m_VersionText);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()

BOOL CAboutDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	const int S_SIZE = 256;
	char s[S_SIZE];

	sprintf_s(s, S_SIZE, "Based on winDSK8 Kernel Version %s", C8X_CONTROL_getVersionString());
	m_VersionText.SetWindowText(s);

	return TRUE;   // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}


// CC8X_ControlDlg dialog




CC8X_ControlDlg::CC8X_ControlDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(CC8X_ControlDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CC8X_ControlDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_SLIDER1, m_Gain);
}

BEGIN_MESSAGE_MAP(CC8X_ControlDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDCANCEL, &CC8X_ControlDlg::OnBnClickedCancel)
	ON_BN_CLICKED(IDC_ResetDspBtn, &CC8X_ControlDlg::OnBnClickedResetdspbtn)
	ON_BN_CLICKED(IDC_LoadAndRunBtn, &CC8X_ControlDlg::OnBnClickedLoadandrunbtn)
	ON_NOTIFY(NM_RELEASEDCAPTURE, IDC_SLIDER1, &CC8X_ControlDlg::OnNMReleasedcaptureSlider1)
END_MESSAGE_MAP()


// CC8X_ControlDlg message handlers

BOOL CC8X_ControlDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// *****************************************************************************
	// begin connection specific initialization code

	// set up host interface configuration
	// WINDSK8_BAUD_xxxxxx are defined in DSP8/wuindsk8_enums.h
	if(!C8X_CONTROL_InitializeHostInterface(COM5, WINDSK8_BAUD_921600)) {	
//	if(!C8X_CONTROL_InitializeHostInterface(COM40, WINDSK8_BAUD_460800)) {	
		AfxMessageBox("Start-up failed.");
		EndDialog(IDCANCEL);
		return TRUE;
	}

	// end connection specific initialization code
	// *****************************************************************************

	// set up gain slider control
	m_Gain.SetRange(0, 100, true);
	m_Gain.SetPos(0);
	m_Gain.SetTicFreq(10);

	DspIsRunning = false;			// flag DSK as not started yet

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CC8X_ControlDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CC8X_ControlDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CC8X_ControlDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CC8X_ControlDlg::OnBnClickedCancel()
{
	// TODO: Add your control notification handler code here
	CDialogEx::OnCancel();
}

void CC8X_ControlDlg::OnBnClickedResetdspbtn()
{
	DspIsRunning = false;

	if(!C8X_CONTROL_ResetDsp()) {
		AfxMessageBox("DSP Reset Failed");
		return;
	}
}

void CC8X_ControlDlg::OnBnClickedLoadandrunbtn()
{
	DspIsRunning = false;
	m_Gain.SetPos(0);

	if(!C8X_CONTROL_ResetAndRunCOFF("DSP8_CCS4\\TalkThru_6713\\Release\\TalkThru_6713.out")) {
//	if(!C8X_CONTROL_ResetAndRunCOFF("DSP8_CCS4\\TalkThru_OMAP\\Release\\TalkThru_OMAP.out")) {
		AfxMessageBox("Program Load Failed");
		return;
	}

	if(!C8X_CONTROL_GetSymbolValue("_Gain", &GainAddress)) {
		AfxMessageBox("_Gain address not found in symbol table.");
		return;
	}

	DspIsRunning = true;
}

void CC8X_ControlDlg::OnNMReleasedcaptureSlider1(NMHDR *pNMHDR, LRESULT *pResult)
{
	if(DspIsRunning) {	
		double setting = (double)(m_Gain.GetPos()) / 4.0; // 0db to -25db adjustment range
		float data = static_cast<float>(pow(10.0, -setting / 20.0));
		if(!C8X_CONTROL_WriteFloat(GainAddress, 1, &data)) {
			AfxMessageBox("DSP Write Failed");
			return;
		}
	}
	*pResult = 0;
}
