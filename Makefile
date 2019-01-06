SRC_DIR = src
FLEX_FILE := $(SRC_DIR)/lexer.lex
FLEX_SRC := $(FLEX_FILE:.lex=.c)
BISON_FILE := $(SRC_DIR)/parser.y
BISON_SRC := $(BISON_FILE:.y=.tab.c)
BISON_HEADERS := $(BISON_SRC:.c=.h)

all: flex cpp

cpp: ./mysh

flex: bison $(FLEX_SRC)

bison: $(BISON_SRC)

$(BISON_SRC) : %.tab.c : %.y
	bison -o $@ -d $<

$(FLEX_SRC) : %.c : %.lex
	flex -o $@ $<

CPP_SOURCES := $(filter-out $(BISON_SRC) $(FLEX_SRC),$(shell find $(SRC_DIR) -name '*.c'))
OBJ_FILES := $(CPP_SOURCES:.c=.o) $(BISON_SRC:.c=.o) $(FLEX_SRC:.c=.o)

./mysh: $(OBJ_FILES)
	$(CC) $(CFLAGS) $(OBJ_FILES) -lreadline -o mysh

$(OBJ_FILES) : %.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean: CLEAN_FLEX CLEAN_BISON CLEAN_OBJ CLEAN_EXEC

CLEAN_OBJ:
	rm -Rf $(OBJ_FILES)

CLEAN_EXEC:
	rm -Rf ./mysh

CLEAN_FLEX: 
	rm -Rf $(FLEX_SRC)

CLEAN_BISON:
	rm -Rf $(BISON_SRC) $(BISON_HEADERS)
