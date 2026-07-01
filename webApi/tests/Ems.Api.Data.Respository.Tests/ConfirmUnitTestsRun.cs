using Shouldly;

namespace Ems.Api.Data.Respository.Tests;

public class ConfirmUnitTestsRun
{
    [Theory]
    [InlineData(9,1,10)]
    public void ConfirmUnitTestsRunAsExpected(int first, int second, int expectedResult)
    {
        var sum = first + second;
        expectedResult.ShouldBe(sum);        
    }
}
