<?php

use PHPUnit\Framework\TestCase;

final class PhpUnitFailTest extends TestCase
{
    public function testDummy()
    {
        $this->assertEmpty("Hello world");
    }
}
