# Overriding equals and hashcode methods
* [so disscussion](http://stackoverflow.com/questions/27581/what-issues-should-be-considered-when-overriding-equals-and-hashcode-in-java)
* [Equals and Hash Code](http://www.javaranch.com/journal/2002/10/equalhash.html)
* [HashCode and Equals method in Java object – A pragmatic concept](http://www.javaworld.com/article/2074996/hashcode-and-equals-method-in-java-object---a-pragmatic-concept.html)

Whenever a.equals(b), then a.hashCode() must be same as b.hashCode().

#### In practice:
If you override one, then you should override the other. Use the same set of fields that you use to compute equals() to compute hashCode().

> FatMinMin's note: You can return the same hashcode for different objects that return false for equals methods. Just like the hash function may collide.

```java
public class Test
{
	private int num;
	private String data;
	public boolean equals(Object obj)
	{
		if(this == obj)
			return true;
			if((obj == null) || (obj.getClass() != this.getClass()))
				return false;
			// object must be Test at this point
			Test test = (Test)obj;
			return num == test.num &&
			(data == test.data || (data != null && data.equals(test.data)));
		}

		public int hashCode()
		{
			int hash = 7;
			hash = 31 * hash + num;
			hash = 31 * hash + (null == data ? 0 : data.hashCode());
			return hash;
		}

		// other methods
}
```
