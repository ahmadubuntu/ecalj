include ../Makefile.define

# directroy where input/output files are saved.
TARGET=ni_crpa
# material in the tests.
MATERIAL=ni

all: help

help:
	@echo "Do not call this Makefile alone."

# exec default case for $(TARGET).
$(TARGET).exec:
	# exec lmfa command.
	$(bindir)/lmfa $(MATERIAL) > llmfa
	# exec lmf command.
	mpirun -np $(mpi_size) $(bindir)/lmf-MPIK $(MATERIAL) > llmf
	# exec epsPP_lmfh command.
	rm Sc*
	$(bindir)/genMLWFx $(MATERIAL) -np $(mpi_size) 
	@echo  >> ../summary.txt
	head -1000 Screening_W-v > Screening_W-v.h
	head -1000 Screening_W-v_crpa > Screening_W-v_crpa.h
	@-$(bindir)/diffnum2 Screening_W-v.h $(REFDIR)/Screening_W-v.h && echo "PASSED: $(TARGET) Screening_W-v.h" >> ../summary.txt || echo "FAILED: $(TARGET) Screening_W-v.h" >> ../summary.txt
	@-$(bindir)/diffnum2 Screening_W-v_crpa.h $(REFDIR)/Screening_W-v_crpa.h && echo "PASSED: $(TARGET) Screening_W-v_crpa.h" >> ../summary.txt || echo "FAILED: $(TARGET) Screening_W-v_crpa.h" >> ../summary.txt

# check default case for $(TARGET).
$(TARGET).check:
	# add summary.txt
	@echo  >> ../summary.txt
	@-$(bindir)/diffnum2 Screening_W-v.h $(REFDIR)/Screening_W-v.h && echo "PASSED: $(TARGET) Screening_W-v.h" >> ../summary.txt || echo "FAILED: $(TARGET) Screening_W-v.h" >> ../summary.txt
	@-$(bindir)/diffnum2 Screening_W-v_crpa.h $(REFDIR)/Screening_W-v_crpa.h && echo "PASSED: $(TARGET) Screening_W-v_crpa.h" >> ../summary.txt || echo "FAILED: $(TARGET) Screening_W-v_crpa.h" >> ../summary.txt
# exec case1 for $(TARGET).
$(TARGET).case1.exec:
	@echo "nothing to exec for $@"

# check case1 for $(TARGET).
$(TARGET).case1.check:
	@echo "nothing to check for $@"
