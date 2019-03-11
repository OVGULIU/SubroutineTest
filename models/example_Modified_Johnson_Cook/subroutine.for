      SUBROUTINE UHARD(SYIELD,HARD,EQPLAS,EQPLASRT,TIME,DTIME,TEMP,
     1     DTEMP,NOEL,NPT,LAYER,KSPT,KSTEP,KINC,CMNAME,NSTATV,
     2     STATEV,NUMFIELDV,PREDEF,DPRED,NUMPROPS,PROPS)
C
	  INCLUDE 'aba_param_dp.INC'
C
	  CHARACTER*80 CMNAME
	  DIMENSION HARD(3), STATEV(NSTATV), TIME(1), PREDEF(NUMFIELDV), DPRED(NUMFIELDV), PROPS(*)
	  REAL*8 A1,b1,b2,b3,n1,L1,L2,e,edot,edot0,edotn,T,Tr,Tm,Th,Sp,einv, edinv
	  REAL*8 Ehard,Ehard_e,EDhard,EDhard_e,EDhard_ed,Tsoft,Tsoft_e,Tsoft_T
      A1 = PROPS(1)
      n1 = PROPS(2)
      b1 = PROPS(3)
      b2 = PROPS(4)
      b3 = PROPS(5)
      L1 = PROPS(6)
      L2 = PROPS(7)
      edot0 = PROPS(8)
      Tr = PROPS(9)
      Tm = PROPS(10)

      e = max(EQPLAS, 1e-6)
      einv = 1.0 / max(e, 1.0D-2)
      edot = EQPLASRT
      edotn = max(edot / edot0, 1.0D-3)
      edinv = 1.0 / max(edotn, 1.0D-2)
      T = TEMP
      Th = (T - Tr) / (Tm - Tr)

      Ehard = A1 * e ** n1
      Ehard_e = n1 * A1 * einv ** (1.0D0 - n1)

      EDhard = (1 + (b1 + e * (b2 + e * b3)) * log(edotn))
      EDhard_e = (b2 + 2.0D0 * b3 * e) * log(edotn)
      EDhard_ed = (b1 + e * (b2 + e * b3)) * edinv

      Tsoft = exp((L1 + L2 * e) * Th)
      Tsoft_e = Th * L2 * Tsoft
      Tsoft_T = (L1 + L2 * e) * Tsoft / (Tm - Tr)

      SYIELD = Ehard * EDhard * Tsoft
      HARD(1) = Ehard * EDhard * Tsoft_e + Ehard * EDhard_e * Tsoft + Ehard_e * EDhard * Tsoft
      HARD(2) = Ehard * EDhard_ed * Tsoft
      HARD(3) = Ehard * EDhard * Tsoft_T

      return
      end