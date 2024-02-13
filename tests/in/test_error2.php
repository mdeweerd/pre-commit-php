<?php

namespace SomeTest;

class TestError2
{
    private $var;
    public function getKeys()
    {
        return array_keys(get_object_vars($this));
    }
}
