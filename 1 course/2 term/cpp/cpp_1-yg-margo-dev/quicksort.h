#ifndef QUICKSORT_H
#define QUICKSORT_H

#include "phonebook.h"
#include <vector>

// Recursive sort of m_A from index l to index h
template< typename T >
void sort(std::vector< T > &a, int l, int h, bool ascending);

template< typename T, bool descending >
void quicksort(std::vector< T > &a)
{
	if (a.size() <= 0)
	{
		return;
	}
	bool ascending = !descending;
	sort< T >(a, 0, a.size() - 1, ascending);
}

template< typename T >
void sort(std::vector< T > &a, int l, int h, bool ascending)
{
	int i = l;
	int j = h;

	// Select median of a[l], a[h] and a[(l + h) / 2]
	int m = (i + j) / 2;
	T val = a[i];
	if (val < a[m])
	{
		if (val < a[j])
		{
			val = (a[m] < a[j]) ? a[m] : a[j];
		}
	}
	else
	{
		if (val > a[j])
		{
			val = (a[m] > a[j]) ? a[m] : a[j];
		}
	}

	// Partition - different for ascending and descending order
	if (ascending)
	{
		while (i <= j)
		{
			while (a[i] < val)
			{
				i++;
			}
			while (a[j] > val)
			{
				j--;
			}
			if (i <= j)
			{
				T t = a[i];
				a[i++] = a[j];
				a[j--] = t;
			}
		}
	}
	else
	{
		while (i <= j)
		{
			while (a[i] > val)
			{
				i++;
			}
			while (a[j] < val)
			{
				j--;
			}
			if (i <= j)
			{
				T t = a[i];
				a[i++] = a[j];
				a[j--] = t;
			}
		}
	}

	// Sort sub-arrays
	if (j > l)
		sort(a, l, j, ascending);
	if (i < h)
		sort(a, i, h, ascending);
}

#endif	  // QUICKSORT_H
