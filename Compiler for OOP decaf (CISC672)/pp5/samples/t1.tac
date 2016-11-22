main:
	BeginFunc 24 ;
	_tmp0 = "hello" ;
	s = _tmp0 ;
	_tmp1 = 4 ;
	_tmp2 = 5 ;
	PushParam _tmp2 ;
	PushParam _tmp1 ;
	_tmp3 = LCall _test ;
	PopParams 8 ;
	c = _tmp3 ;
	PushParam c ;
	LCall _PrintInt ;
	PopParams 4 ;
	PushParam s ;
	LCall _PrintString ;
	PopParams 4 ;
	EndFunc ;
_test:
	BeginFunc 4 ;
	_tmp4 = a + b ;
	Return _tmp4 ;
	EndFunc ;
