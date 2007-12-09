
module Math
  def self.min(a,b)
    a > b ? b : a
  end
  def self.max(a,b)
    a > b ? a : b
  end
end

class Diff

  SAME = "SAME"
  ADD = "ADD"
  DEL = "DEL"

  def self.makeDiff(array1,array2,&compproc)
    compproc = Proc.new {|a,b| a == b } if compproc == nil
    table = Array.new(array1.size+1)
    (array1.size+1).times {|x| table[x] = Array.new(array2.size+1) }
    (array1.size+1).times {|x| table[x][0] = x }
    (array2.size+1).times {|y| table[0][y] = y }
    array1.size.times do |x|
      array2.size.times do |y|
        table[x+1][y+1] = 
          if(compproc.call(array1[x],array2[y]))
            table[x][y] 
          else
            Math.min(table[x+1][y], table[x][y+1])+1
          end
      end
    end
    ret = Array.new
    posx = array1.size
    posy = array2.size
    while(!(posx == 0 && posy == 0))
      if(posx > 0 && posy > 0 && compproc.call(array1[posx-1],array2[posy-1]))
        ret.unshift(addmarker(array1[posx-1],SAME,array2[posy-1]))
        posx -= 1
        posy -= 1
      elsif ((posx == 0 )|| 
            (posy > 0 && table[posx][posy-1] < table[posx-1][posy]))
        ret.unshift(addmarker(array2[posy-1],ADD))
        posy -= 1
      else
        ret.unshift(addmarker(array1[posx-1],DEL))
        posx -= 1
      end
    end
 
    return ret
  end
  
  def self.addmarker(item,mark,old=nil)
    class << item
      attr_accessor :diffmark,:old
    end
    item.diffmark = mark
    item.old = old
    return item
  end
end


if __FILE__ == $0

  require 'test/unit'
  
  class TestDiff < Test::Unit::TestCase
    def test_same
      a = ["hoge","fuga","foo","bar"]
      b = ["hoge","fuga","foo","bar"]
      r = Diff.makeDiff(a,b)
      assert_equal(a.size,r.size)
      r.each{|i| assert_equal(Diff::SAME, i.diffmark) }
    end

    def test_add
      a = ["hoge","fuga","foo","bar"]
      b = ["hoge","fuga","bar"]
      r = Diff.makeDiff(a,b)
      assert_equal(a.size,r.size)
      r.delete_if{|i| i.diffmark == Diff::SAME}
      assert_equal(1,r.size)
      assert_equal(r[0].diffmark,Diff::DEL)
    end

    def test_add2
      a = ["hoge","fuga","foo","bar"]
      b = ["fuga","bar"]
      r = Diff.makeDiff(a,b)
      assert_equal(a.size,r.size)
      r.delete_if{|i| i.diffmark == Diff::SAME}
      assert_equal(2,r.size)
      assert_equal(r[0].diffmark,Diff::DEL)
      assert_equal(r[1].diffmark,Diff::DEL)
    end

    def test_add3
      a = ["1","2","3","4","5","6","7","8","9"]
      b = ["1","2","3","4","5","6","X","7","8","9"]
      r = Diff.makeDiff(a,b)
      assert_equal(b.size,r.size)
      r.delete_if{|i| i.diffmark == Diff::SAME}
      assert_equal(1,r.size)
      assert_equal(r[0].diffmark,Diff::ADD)
    end
    def test_del
      a = ["hoge","foo","bar"]
      b = ["hoge","fuga","foo","bar"]
      r = Diff.makeDiff(a,b)
      assert_equal(b.size,r.size)
      r.delete_if{|i| i.diffmark == Diff::SAME}
      assert_equal(1,r.size)
      assert_equal(r[0].diffmark,Diff::ADD)
    end
    def test_del
      a = ["hoge","foo","bar"]
      b = ["hoge","fuga","bar"]
      r = Diff.makeDiff(a,b)
      assert_equal(a.size+1,r.size)
      r.delete_if{|i| i.diffmark == Diff::SAME}
      assert_equal(2,r.size)
      assert_equal(r[0].diffmark,Diff::ADD)
      assert_equal(r[1].diffmark,Diff::DEL)
    end

  end

end
