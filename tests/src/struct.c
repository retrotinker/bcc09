/* structures, unions, bit fields and typedefs */

typedef struct point {
	int x, y;
} point;

struct rec {
	char tag;
	int count;
	long total;
	point where;
	struct rec *next;
	char name[6];
};

union num {
	long l;
	int i[2];
	char c[4];
};

struct flags {
	unsigned ready : 1;
	unsigned mode : 3;
	unsigned level : 4;
};

struct rec r1, r2 = { 'a', 3, 70000L, { 1, 2 }, &r1, "abc" };
union num n;
struct flags f;
point pts[4];

int area(p, q)
point *p, *q;
{
	return (q->x - p->x) * (q->y - p->y);
}

int structs()
{
	struct rec *rp = &r2;

	r1 = r2;
	r1.where.x = rp->next->count;
	rp->next->name[0] = 'z';
	pts[2].y = sizeof(struct rec);
	n.l = 0x12345678L;
	f.ready = 1;
	f.mode = 5;
	f.level = f.mode + 2;
	return area(&pts[0], &pts[1]) + n.i[1] + n.c[3] + f.level;
}
