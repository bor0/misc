#include <iostream>

class Link {

	class LinkList {
		public:
		int value;
		LinkList *next;

		LinkList(int value) {
			next = 0; this->value = value;
		}

	};

	LinkList *first;
	public:

	Link(int value=0) {
		first = new LinkList(value);
	}

	void AddLink(int value) {
		LinkList *temp = first;

		while ((*temp).next != 0) temp = (*temp).next;

		LinkList *link = new LinkList(value);
		(*temp).next = link;
	}

	void DelLink(int value) {
		LinkList *temp = first; LinkList *temp2;

		while (1) {
			temp2 = (*temp).next;
			if ((*temp2).value == value) break;
			temp = (*temp).next;
		}

		(*temp).next = (*temp2).next; delete temp2;

	}


	void DisplayLinks() {
		int i=0;
                LinkList *temp = first;

                while ((*temp).next != 0) {
			printf("%d) %d\n", ++i, (*temp).value);
			temp = (*temp).next;
		}
	}

	~Link() {

		LinkList *temp = first; LinkList *temp2;

		while ((*temp).next != 0)
			temp2 = temp; temp = (*temp).next; delete temp2;


		delete temp; delete first;
	}

};

int main() {


	Link a = 5;

	a.AddLink(1);
	a.AddLink(2);
	a.AddLink(3);
	a.AddLink(4);
	a.DisplayLinks();

	a.DelLink(2);
	a.DisplayLinks();

	return 0;

}
