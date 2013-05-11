# coding: UTF-8
require "csv"

def block_table(element)
  csv = CSV.parse(element.innerYATML)
  ret = ["table",{}]
  csv.each do |l|
    row = ["tr",{}]
    l.each do |i|
      cont = i==nil ? [] : convertYatml2Wabisabi(i)
      row << (["td",{}] + cont)
    end
    ret << row
  end
  return ret
end

# vim: sw=2 : ts=1000 :
