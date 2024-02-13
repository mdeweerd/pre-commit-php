# Tests

## php-cs

### Test valid file

```test
../pre_commit_hooks/php-cs.sh in/test.php
```

```output
[1;32mBegin PHP Codesniffer[0m 
[1;37mRunning command [0;32mphpcs 'in/test.php'[0m
[1;35mErrors detected by PHP CodeSniffer ... [0m 
```

### Test file with space

```test
../pre_commit_hooks/php-cs.sh 'in/test space.php'
```

```output
[1;32mBegin PHP Codesniffer[0m 
[1;37mRunning command [0;32mphpcs 'in/test space.php'[0m
[1;35mErrors detected by PHP CodeSniffer ... [0m 
FOUND 1 ERROR AFFECTING 1 LINE
 2 | ERROR | Missing file doc comment
```

### Test file with space

```test
../pre_commit_hooks/php-cs.sh 'in/test_error2.php'
```

```output
[1;32mBegin PHP Codesniffer[0m 
[1;37mRunning command [0;32mphpcs 'in/test_error2.php'[0m
[1;35mErrors detected by PHP CodeSniffer ... [0m 
FOUND 4 ERRORS AFFECTING 4 LINES
 2 | ERROR | Missing file doc comment
 5 | ERROR | Missing doc comment for class TestError2
 7 | ERROR | Private member variable "var" must be prefixed with an underscore
 8 | ERROR | Missing doc comment for function getKeys()
```



## php-cbf

### Test valid file

```test
../pre_commit_hooks/php-cbf.sh in/test.php
```

```output
[1;32mBegin PHP Code Beautifier and Fixer[0m 
[1;37mRunning command [0;32mphpcbf 'in/test.php'[0m
```

### Test file with space

```test
../pre_commit_hooks/php-cbf.sh 'in/test space.php'
```

```output
[1;32mBegin PHP Code Beautifier and Fixer[0m 
[1;37mRunning command [0;32mphpcbf 'in/test space.php'[0m
```


## php-lint

### Test valid file

```test
../pre_commit_hooks/php-lint.sh in/test.php
```

```output
[1;32mBegin PHP Linter[0m 
```

### Test missing file

```test
../pre_commit_hooks/php-lint.sh "in/testnofile.php"
```

```output
[1;32mBegin PHP Linter[0m 
Could not open input file: in/testnofile.php
[1;35m1[0m [0;33mPHP Parse error(s) were found![0m
```

### Test file with space

```test
../pre_commit_hooks/php-lint.sh "in/test space.php"
```

```output
[1;32mBegin PHP Linter[0m 
```


## phpunit

### OK

```test
../pre_commit_hooks/php-unit.sh "in/PhpUnit1Test.php"
```

```output
[1;32mBegin PHP Unit Task Runner[0m 
[1;37mRunning command [0;32mphpunit[0m
```

### NOK

```test
../pre_commit_hooks/php-unit.sh "in/PhpUnitFailTest.php"
```

```output
[1;32mBegin PHP Unit Task Runner[0m 
[1;37mRunning command [0;32mphpunit[0m
Failures detected in unit tests...
F                                                                   1 / 1 (100%)
There was 1 failure:
1) PhpUnitFailTest::testDummy
Failed asserting that a string is empty.
FAILURES!
Tests: 1, Assertions: 1, Failures: 1.
```

### Multiple

```test
../pre_commit_hooks/php-unit.sh "in/PhpUnit1Test.php" "in/PhpUnitFailTest.php"
```

```output
[1;32mBegin PHP Unit Task Runner[0m 
[1;37mRunning command [0;32mphpunit[0m
Failures detected in unit tests...
.F                                                                  2 / 2 (100%)
There was 1 failure:
1) PhpUnitFailTest::testDummy
Failed asserting that a string is empty.
FAILURES!
Tests: 2, Assertions: 2, Failures: 1.
```

### All

```test
../pre_commit_hooks/php-unit.sh 
```

```output
[1;32mBegin PHP Unit Task Runner[0m 
[1;37mRunning command [0;32mphpunit[0m
Failures detected in unit tests...
.F                                                                  2 / 2 (100%)
There was 1 failure:
1) PhpUnitFailTest::testDummy
Failed asserting that a string is empty.
FAILURES!
Tests: 2, Assertions: 2, Failures: 1.
```
