
class int(int):
    def times(self):
        return range(self)
    def upto(self, b):
        return range(self, b+1)
    def downto(self, b):
        return range(self, b-1, -1)
    def step(self, b, step=1):
        return range(self, b, step)

class list(list):
    def __and__(self, b):
        return list(set(self) & set(b))
    def __or__(self, b):
        return list(set(self) | set(b))
    def length(self):
        return len(self)
    def size(self):
        return len(self)
    def uniq(self):
        # safe
        return sorted(set(self), key=self.index)
    def assoc(self, s):
        try:
            for i in self:
                if i[0] == s:
                    return i
            return None
        except:
            return None 
    def delete(self, l):
        # unsafe
        for b in l:
            for i in range(self.count(b)):
                self.remove(b)
        return self

i = int(5)

print i.times()
print i.upto(10)
print i.downto(2)
print i.step(10)
print i.step(10, 2)

l = list([1,2,3,4,5,1,2,3])
l2 = list([[1,2],[3,4],[5,6]])
l3 = list([1,4,7])

print l.size()
print l.uniq()
print l.assoc(4)
print l & l3
print l | l3
print l.delete(l3)
