
// C8X_ControlDlg.h : header file
//

#pragma once
#include "afxcmn.h"

#include "C8X_CONTROL_DLL.h"


// CC8X_ControlDlg dialog
class CC8X_ControlDlg : public CDialogEx
{
// Construction
public:
	CC8X_ControlDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_C8X_CONTROL_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;
	bool DspIsRunning;
	Uint32 GainAddress;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	CSliderCtrl m_Gain;
	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedResetdspbtn();
	afx_msg void OnBnClickedLoadandrunbtn();
	afx_msg void OnNMReleasedcaptureSlider1(NMHDR *pNMHDR, LRESULT *pResult);
};
