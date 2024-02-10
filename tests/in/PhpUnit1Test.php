<?php

use PHPUnit\Framework\TestCase;

final class PhpUnit1Test extends TestCase
{
    public function testDummy()
    {
        $this->assertSame(false, false);
    }
}
