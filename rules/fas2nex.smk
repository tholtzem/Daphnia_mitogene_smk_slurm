rule aligned_fas2nex:
  input:
    "muscle/{sets}/{gene}_multi.super5.fas"
  output:
    "muscle/{sets}/{gene}_multi.super5.nex"
  log: "log/{sets}/{gene}_multi.super5.nex.log"
  message: " --- aligned as2nex --- "
  shell:
    """
    python scripts/aligned_fas2nex.py {input} {output} 2> {log}
    """

