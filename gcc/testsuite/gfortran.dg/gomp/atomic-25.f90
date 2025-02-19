! { dg-do compile }

module m
use iso_fortran_env
implicit none
integer, parameter :: mrk = maxval(real_kinds)
integer x, r, z
real(kind(4.0d0)) d, v
real(mrk) ld

contains
subroutine foo (y, e, f)
  integer :: y
  real(kind(4.0d0)) :: e
  real(mrk) :: f
  !$omp atomic update seq_cst fail(acquire)
  x = min(x, y)
  !$omp atomic relaxed fail(relaxed)
  d = max (e, d)
  !$omp atomic fail(SEQ_CST)
  d = min (d, f)
  !$omp atomic seq_cst compare fail(relaxed)  ! { dg-error "Sorry, COMPARE clause in ATOMIC at .1. is not yet supported" }
  if (x == 7) x = 24
  !$omp atomic compare  ! { dg-error "Sorry, COMPARE clause in ATOMIC at .1. is not yet supported" }
  if (x == 7) x = 24
  !$omp atomic compare  ! { dg-error "Sorry, COMPARE clause in ATOMIC at .1. is not yet supported" }
  if (x == 123) x = 256
  !$omp atomic compare  ! { dg-error "Sorry, COMPARE clause in ATOMIC at .1. is not yet supported" }
  if (ld == f)  ld = f + 5.0_mrk
  !$omp atomic compare  ! { dg-error "Sorry, COMPARE clause in ATOMIC at .1. is not yet supported" }
  if (x == 9) then
    x = 5
  endif
  !$omp atomic compare update capture seq_cst fail(acquire)  ! { dg-error "Sorry, COMPARE clause in ATOMIC at .1. is not yet supported" }
  if (x == 42) then
    x = f
  else
    v = x
  endif
  !$omp atomic capture compare weak  ! { dg-error "Sorry, COMPARE clause in ATOMIC at .1. is not yet supported" }
  if (x == 42) then
    x = f
  else
    v = x
  endif
  !$omp atomic capture compare fail(seq_cst)  ! { dg-error "Sorry, COMPARE clause in ATOMIC at .1. is not yet supported" }
  if (d == 8.0) then
    d = 16.0
  else
    v = d
  end if
end
end module
